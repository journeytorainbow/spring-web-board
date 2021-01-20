package org.donut.task;

import java.io.*;
import java.nio.file.*;
import java.text.*;
import java.util.*;
import java.util.stream.*;

import org.donut.domain.*;
import org.donut.mapper.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.scheduling.annotation.*;
import org.springframework.stereotype.*;

import lombok.*;
import lombok.extern.log4j.*;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = {@Autowired})
	private BoardAttachMapper attachMapper;
	
	// 어제에 해당되는 날짜의 폴더 이름 구하기
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance(); // Calendar 객체 얻기
		
		cal.add(Calendar.DATE, -1); // 어제에 해당되는 '일'
		
		String str = sdf.format(cal.getTime()); // Date객체를 특정 문자열 포맷으로 변환
		
		String result = str.replace("-", File.separator);
		
		log.info("getFolderYesterDay's result : " + result );
//		return str.replace("-", File.separator); // 윈도우 기준 yyyy\MM\dd 형태가 됨
		return result;
	}
	
	@Scheduled(cron = "0 0 2 * * *") // 매일 새벽 2시에 동작
	public void checkFiles() throws Exception {
		
		log.warn("File Check Task run ..................");
		
		log.warn(new Date()); // 오늘 날짜 정보
		
		// DB로 부터 이전날 등록된 첨부 파일 리스트 전부 가져오기
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// BoardAttachVO객체를 Path객체로 변환
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\uploadfiles", vo.getUploadPath(), vo.getUploadPath() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		// 이미지 파일의 섬네일도 추가
		fileList.stream().filter(vo -> vo.isFileType() == true)
		.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
		.forEach(p -> fileListPaths.add((p)));
		
		log.warn("==================================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		// 어제 날짜에 해당되는 폴더
		File targetDir = Paths.get("C:\\uploadfiles", getFolderYesterDay()).toFile(); // Path객체를 File객체로
		
		// targetDir의 파일들을 File배열로 반환하는데, 
		// fileListPaths 리스트에 포함되어있지 않은 Path객체들로만 구성
		// 즉 폴더에는 존재하나 DB에는 존재하지 않는 파일들의 배열
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("=====================================================");
		
		// DB엔 없고 폴더에만 존재하는 파일들을 폴더 상에서 삭제
		for (File file : removeFiles) {
			
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}