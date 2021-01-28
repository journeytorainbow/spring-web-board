package org.donut.security.domain;

import java.util.*;
import java.util.stream.*;

import org.donut.domain.*;
import org.springframework.security.core.*;
import org.springframework.security.core.authority.*;
import org.springframework.security.core.userdetails.*;

import lombok.*;

@Getter
public class CustomUser extends User {
	
	private static final long serialVersionUID = 1L;
	
	private MemberVO member;
	
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}

	public CustomUser(MemberVO vo) {
		super(vo.getUserid(), vo.getUserpw(), vo.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
				.collect(Collectors.toList()));
		
		this.member = vo;
	}
}