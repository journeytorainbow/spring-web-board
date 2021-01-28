package org.donut.security;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import org.springframework.security.access.*;
import org.springframework.security.web.access.*;

import lombok.extern.log4j.*;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
	
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		log.error("Access Denied Handler");
		log.error("Redirect");
		
		response.sendRedirect("/accessError");
	}
}