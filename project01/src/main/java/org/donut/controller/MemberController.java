package org.donut.controller;

import org.donut.domain.*;
import org.donut.service.*;
import org.springframework.http.*;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.*;
import org.springframework.security.crypto.password.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.*;

import lombok.*;
import lombok.extern.log4j.*;

@Controller
@Log4j
@RequestMapping("/member/*")
@AllArgsConstructor
public class MemberController {
	
	private MemberService memberService;
	private PasswordEncoder pwencoder;
	
	@GetMapping("/register")
	@PreAuthorize("isAnonymous()")
	public void register() {
		
	}
	
	@PostMapping("/register")
	@PreAuthorize("isAnonymous()")
	public String register(MemberVO member, AuthVO auth, String userid) {
		
		log.info("user id : " + userid);
		int result = memberService.checkId(userid);
		
		if(result == 1) {
			
			log.info(userid + " 아이디 중복으로 회원가입 실패");
			return "/member/register";
			
		} else if (result == 0) {			
			member.setUserid(userid);
			member.setUserpw(pwencoder.encode(member.getUserpw()));
			auth.setUserid(userid);
			
			log.info("member 객체 : " + member);
			log.info("auth 객체 : " + auth);
			memberService.register(member, auth);
			
			log.info(userid + " 회원 가입 성공");
		}
		
		return "redirect:/board/list";
	}
	
	@ResponseBody
	@PostMapping(value = "/idCheck", consumes = "application/json", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<String> checkId(@RequestBody MemberVO member) {
		
		log.info("Check for duplicate userid : " + member.getUserid());
		
		int result = memberService.checkId(member.getUserid());
		
		log.info("unser id count : " + result);
		
		return result == 1 ? new ResponseEntity<>("1", HttpStatus.OK) : new ResponseEntity<>("0", HttpStatus.OK);
	}
}