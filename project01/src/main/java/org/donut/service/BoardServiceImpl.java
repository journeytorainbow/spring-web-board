package org.donut.service;

import java.util.*;


import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.*;

import lombok.*;
import lombok.extern.log4j.*;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	private BoardMapper mapper;
	
	private BoardAttachMapper attachMapper;
	
	private ReplyMapper replyMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		
		log.info("register...." + board);
		
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		
		log.info("get...." + bno);
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("modify......" + board);
		
		attachMapper.deleteAll(board.getBno()); // DB에서 해당 게시물의 첨부파일 전부 삭제
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		
		log.info("remove...." + bno);
		
		replyMapper.deleteAll(bno);
		
		attachMapper.deleteAll(bno); // db에서 첨부파일정보 삭제
		
		return mapper.delete(bno) == 1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		
//		log.info("get list......");
//		return mapper.getList();
//	}
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		
		log.info("get list with criteria......" + cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		
		log.info("get attach list by bno : " + bno);
		return attachMapper.findByBno(bno);
	}
}