package org.donut.mapper;


import java.util.*;

import org.apache.ibatis.annotations.*;
import org.donut.domain.*;

public interface BoardMapper {
	
//	@Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	@Insert("insert into tbl_board (bno, title, content, writer) values (seq_board.nextval, #{title}, #{content}, #{writer})")
	public void insert(BoardVO board);
	
	@Insert("insert into tbl_board (bno, title, content, writer) values (#{bno}, #{title}, #{content}, #{writer})")
	@SelectKey(statement="select seq_board.nextval from dual", keyProperty="bno", before=true, resultType=long.class)
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);
	
	
}