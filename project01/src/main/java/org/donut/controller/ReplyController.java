package org.donut.controller;

import org.donut.domain.*;
import org.donut.service.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import lombok.*;
import lombok.extern.log4j.*;

@RestController
@RequestMapping("/replies/")
@Log4j
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	
	@PostMapping(value = "/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		
		log.info("ReplyVO : " + vo);
		
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT : " + insertCount);
		
		return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}