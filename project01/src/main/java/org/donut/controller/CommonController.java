package org.donut.controller;

import org.springframework.security.core.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;

import lombok.extern.log4j.*;

@Controller
@Log4j
public class CommonController {

	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		
		log.info("접근 거부 : " + auth);
		model.addAttribute("msg", "Access Denied");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		
		log.info("error : " + error);
		log.info("logout : " + logout);
		
		if (error != null) {
			
			model.addAttribute("error", "Login error!! Check out your account!");
		}
		
		if (logout != null) {
			
			model.addAttribute("logout", "Logout!!");
		}
	}
	
	@GetMapping("/customLogout")
	public void logoutGET() {
		
		log.info("custom logout");
	}
	
	@PostMapping("/customLogout")
	public void logoutPost() {
		
		log.info("post custom logout");
	}
}
