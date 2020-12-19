package org.donut.service;

import java.util.*;

import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.stereotype.*;

import lombok.*;
import lombok.extern.log4j.*;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	private BoardMapper mapper;

	@Override
	public void register(BoardVO board) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public BoardVO get(Long bno) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean modify(BoardVO bno) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean remove(BoardVO bno) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<BoardVO> getList() {
		// TODO Auto-generated method stub
		return null;
	}
}