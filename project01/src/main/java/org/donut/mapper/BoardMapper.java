package org.donut.mapper;


import java.util.*;

import org.apache.ibatis.annotations.*;
import org.donut.domain.*;

public interface BoardMapper {
	
//	@Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
}