package org.donut.service;


import java.util.*;

import org.donut.domain.*;

public interface BoardService {
	
	public void register(BoardVO board);
	
	public BoardVO get(Long bno);
	
	public boolean modify(BoardVO bno);
	
	public boolean remove(BoardVO bno);
	
	public List<BoardVO> getList();
}