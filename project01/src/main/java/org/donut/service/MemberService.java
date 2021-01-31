package org.donut.service;

import org.donut.domain.*;

public interface MemberService {

	public void register(MemberVO member, AuthVO auth);
	public int checkId(String userid);
}