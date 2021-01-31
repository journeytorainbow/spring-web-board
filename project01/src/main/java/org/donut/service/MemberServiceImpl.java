package org.donut.service;

import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.*;

import lombok.*;
import lombok.extern.log4j.*;

@Service
@AllArgsConstructor
@Log4j
public class MemberServiceImpl implements MemberService {
	
	private MemberMapper memberMapper;
	private AuthMapper authMapper;
	
	@Transactional
	@Override
	public void register(MemberVO member, AuthVO auth) {
		
		memberMapper.insert(member);
		authMapper.insert(auth);
	}
}