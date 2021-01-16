package org.donut.domain;

import lombok.*;

@Data
public class BoardAttachVO {
	
	private String uuid;
	private String uploadPath;
	private String fileName;
	private String fileType;
	
	private Long bno;
}