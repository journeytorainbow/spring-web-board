package org.donut.service;

import java.util.*;

import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.stereotype.*;

import lombok.*;
import lombok.extern.log4j.*;

@Service
@Log4j
@AllArgsConstructor
public class RelyServiceImpl implements ReplyService {
	
//	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;

	@Override
	public int register(ReplyVO vo) {
		
		log.info("register...." + vo);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		
		log.info("get...." + rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		
		log.info("modify...." + vo);
		return mapper.update(vo);
	}

	@Override
	public int remove(Long rno) {
		
		log.info("remove...." + rno);
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		
		log.info("get Reply List of Board " + bno);
		return mapper.getListWithPaging(cri, bno);
	}
	
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno));
	}
}