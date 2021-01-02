package org.donut.mapper;

import java.util.*;
import java.util.stream.*;

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
public class ReplyMapperTests {
	
	// 테스트 전에 해당 번호(bno)의 게시물이 존재하는지 반드시 확인할 것
	private Long[] bnoArr = {266L, 267L, 269L, 270L, 271L};
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		
		log.info(mapper);
	}
	
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1,  10).forEach(i -> {
			
		ReplyVO vo = new ReplyVO();
		
		//게시물의 번호
		vo.setBno(bnoArr[i % 5]);
		vo.setReply("댓글테스트" + i);
		vo.setReplyer("replyer" + i);
		
		mapper.insert(vo);
		});
	}
	
	@Test
	public void testRead() {
		
		Long targetRno = 10L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		log.info(vo);
	}
	
	@Test
	public void testDelete() {
		
		Long targetRno = 1L;
		
		int count = mapper.delete(targetRno);
		
		log.info("DELETE COUNT : " + count);
	}
	
	@Test
	public void testUpdate() {
		
		Long targetRno = 10L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		vo.setReply("Updated Reply");
		
		int count = mapper.update(vo);
		
		log.info("UPDATE COUNT : " + count);
	}
	
	@Test
	public void testList() {
		
		Criteria cri = new Criteria();
		// 270번 게시물의 댓글들
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[3]);
		replies.forEach(reply -> log.info(reply));
	}
}