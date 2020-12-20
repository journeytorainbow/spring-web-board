package org.donut.service;

import static org.junit.Assert.assertNotNull;

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
public class BoardServiceTests {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardService service;
	
	@Test
	public void testExist() {
		log.info(service);
		assertNotNull(service);
	}
	
	@Test
	public void testRegister() {
		
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글");
		board.setContent("새로 작성하는 내용");
		board.setWriter("뉴비");
		
		service.register(board);
		
		log.info("생성된 게시물 번호 : " + board.getBno());
	}
	
	@Test
	public void testGetList() {
		
		service.getList().forEach(board -> log.info(board));
	}
	
	@Test
	public void testRead() {
		log.info(service.get(162L));
	}
	
	@Test
	public void testUpdate() {
		
		BoardVO board = service.get(142L);
		
		if (board == null) {
			return;
		}
		
		board.setTitle("수정된 제목입니다.");
		log.info("Modify Result : " + service.modify(board));
	}
}