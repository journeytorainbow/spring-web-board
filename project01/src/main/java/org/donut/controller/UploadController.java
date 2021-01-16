package org.donut.controller;

import java.io.*;
import java.net.*;
import java.nio.file.*;
import java.text.*;
import java.util.*;

import org.donut.domain.*;
import org.springframework.core.io.*;
import org.springframework.http.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.util.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;
import org.donut.domain.*;

import lombok.extern.log4j.*;
import net.coobird.thumbnailator.*;

@Controller
@Log4j
public class UploadController {
	
	// 첨부파일 업로드 화면 처리 메소드 (form을 이용하는 방식)
	@GetMapping("/uploadForm")
	public void uploadForm() {
		
		log.info("upload form");
	}
	
	// 첨부 파일 업로드 처리 메소드
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		// 파일 저장 경로
		String uploadFolder = "C:\\uploadfiles";
		
		for (MultipartFile multipartFile : uploadFile) {
			
			log.info("--------------------------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				// 파일 저장
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	// 첨부파일 업로드 화면 처리 메소드 (Ajax를 이용하는 방식)
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		
		log.info("upload ajax");
	}
	
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<>();
		
		String uploadFolder = "C:\\uploadfiles";
		
		String uploadFolderPath = getFolder();
		// make folder -----
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(uploadPath.exists() == false) { // 해당 경로가 있는지 검사
			uploadPath.mkdirs(); // \yyyy\mm\dd 디렉토리 생성
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE has file path : 마지막 \를 기준으로 잘라낸 문자열이 실제 파일 이름이 됨
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID(); // 파일 이름 중복방지를 위한 UUID값 생성
			uploadFileName = uuid.toString() + "_" + uploadFileName; // 원래 파일이름과 구분하기 위해 _를 추가
			
			// File saveFile = new File(uploadFolder, uploadFileName);
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile); // 첨부 파일 저장
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 이미지 타입 파일인지 체크
				if (checkImageType(saveFile)) {
					
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName)); // 섬네일 이미지 이름에는 s_ 붙이기
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100); // width : 100 , height : 100
					thumbnail.close();
				}
				
				// add to list
				list.add(attachDTO);
				
			} catch (Exception e) {
				log.error(e.getMessage());
			} // end catch
		} // end for
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// 년-월-일 => 년\월\일(window기준) 문자열로 바꾸는 메소드 (경로명 생성 메소드)
	private String getFolder() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date(); // 컴퓨터의 현재 날짜를 읽어서 객체 생성
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator); // 각 운영체제에 맞는 경로 구분자로 replace
	}
	
	// 특정 파일이 이미지 타입인지 검사하는 메소드
	private boolean checkImageType(File file) {
		
		try {
			String contentType = Files.probeContentType(file.toPath()); // file객체를 path객체로 변환 후 파라미터로 넘겨서 파일 타입 확인(String으로 리턴)
			
			return contentType.startsWith("image"); // 파일 타입이 image로 시작하면 true리턴
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) { // 파일의 경로가 포함된 문자열
		
		log.info("file name : " + fileName);
		
		File file = new File("C:\\uploadfiles\\" + fileName);
		
		log.info("file : " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		
		// log.info("download file : " + fileName);
		
		Resource resource = new FileSystemResource("C:\\uploadfiles\\" + fileName);
		
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		// log.info("resource : " + resource);
		
		String resourceName = resource.getFilename();
		// log.info(resourceName);
		
		// remove UUID
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			
			if (userAgent.contains("Trident") || userAgent.contains("MSIE")) {
				log.info("IE Browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			} else if (userAgent.contains("Edge")) {
				log.info("Edge Browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
			} else {
				log.info("Chrome Browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
				log.info("resourceOriginalName : " +resourceOriginalName);
				log.info("downloadName : " + downloadName);
			}
			
			log.info("downloadName : " + downloadName);
			
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
			log.info(headers);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile : " + fileName);
		
		File file;
		
		try {
			
			file = new File("C:\\uploadfiles\\" + URLDecoder.decode(fileName, "UTF-8"));
			
			log.info("삭제 예정 파일 : " + file);
			
			file.delete(); // 이미지 파일일 경우 섬네일이 삭제됨
			
			if (type.equals("image")) {
				
				String largeFileName = file.getAbsolutePath().replace("s_", ""); // 원본 파일 이름
				
				log.info("largeFileName : " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();
			}
		
		} catch (UnsupportedEncodingException e) {
			
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<>("deleted", HttpStatus.OK);
	}
}