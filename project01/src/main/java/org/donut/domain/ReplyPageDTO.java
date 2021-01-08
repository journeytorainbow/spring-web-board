package org.donut.domain;

import java.util.*;

import lombok.*;

@Data
@AllArgsConstructor
//@Getter
public class ReplyPageDTO {
	
	private int replyCnt;
	private List<ReplyVO> list;
}