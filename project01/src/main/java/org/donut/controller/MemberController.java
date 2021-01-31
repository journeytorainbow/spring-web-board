package org.donut.controller;

import java.util.*;

import org.donut.domain.*;
import org.donut.service.*;
import org.springframework.security.access.prepost.*;
import org.springframework.security.crypto.password.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

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
		
		member.setUserid(userid);
		member.setUserpw(pwencoder.encode(member.getUserpw()));
		auth.setUserid(userid);
				
		log.info("member 객체 : " + member);
		log.info("auth 객체 : " + auth);
		memberService.register(member, auth);
		
		return "redirect:/board/list";
	}
}