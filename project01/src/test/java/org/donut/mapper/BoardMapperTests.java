package org.donut.mapper;

import java.util.*;

import org.donut.domain.*;
import org.junit.*;
import org.junit.runner.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.test.context.*;
import org.springframework.test.context.junit4.*;

import lombok.*;
import lombok.extern.log4j.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
	}
	
	@Test
	public void testInsert() {
		
		BoardVO board = new BoardVO();
		board.setTitle("새 글");
		board.setContent("새 내용");
		board.setWriter("뉴비");
		
		mapper.insert(board);
		log.info(board);
	}
	
	@Test
	public void testInsertKey() {
		
		BoardVO board = new BoardVO();
		board.setTitle("새 글");
		board.setContent("새 내용");
		board.setWriter("뉴비");
		
		mapper.insertSelectKey(board);
		log.info(board);
	}
	
	@Test
	public void testRead() {
		
		// 존재하는 게시물 번호로 테스트
		BoardVO board = mapper.read(153L);
		log.info(board);
	}
	
	@Test
	public void testDelete() {
		
		log.info("삭제 개수 : " + mapper.delete(153L));
	}
	
	@Test
	public void testUpdate() {
		
		BoardVO board = new BoardVO();
		// 존재하는 게시물 번호로 테스트
		board.setBno(154L);
		board.setTitle("수정된 제목");
		board.setContent("수정된 내용");
		board.setWriter("testUser");
		
		int count = mapper.update(board);
		log.info("수정된 개수 : " + count);
	}
	
	@Test
	public void testPaging() {
		
		// 한 페이지에 10개씩 출력할 때, 3페이지에 들어갈 데이터 출력
		Criteria cri = new Criteria(3, 10);
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));
	}
}