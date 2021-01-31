package org.donut.mapper;

import org.donut.domain.*;

public interface MemberMapper {
	
	public MemberVO read(String userid);
	public void insert(MemberVO vo);
	public int checkId(String userid);
}
