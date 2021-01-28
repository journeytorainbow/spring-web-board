package org.donut.security;

import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.security.core.userdetails.*;
import org.donut.security.domain.*;

import lombok.*;
import lombok.extern.log4j.*;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {
	
	@Setter(onMethod_ = {@Autowired})
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("Load User By UserName : " + userName);
		
		// userName은 userid를 의미
		MemberVO vo = memberMapper.read(userName);
		
		log.warn("queried by member mapper : " + vo);
		
		// // UserDetails타입을 반환(즉, MemberVO 객체 -> UserDetails타입으로 변환)
		return vo == null ? null : new CustomUser(vo);
	}
}
