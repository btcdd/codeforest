package com.btcdd.codeforest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.MypageRepository;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;

@Service
public class MypageService {
	
	@Autowired
	private JavaMailSender mailSender;

	private static final int postNum = 10; //한 페이지에 출력할 게시물 갯수
	private static final int pageNum_cnt = 5; 		//한번에 표시할 페이징 번호의 갯수	
	
	@Autowired
	private MypageRepository mypageRepository;

	public int changeNickname(UserVo vo) {
		return mypageRepository.changeNickname(vo);
	}

	public int changePassword(UserVo vo) {
		return mypageRepository.changePassword(vo);
	}

	public int deleteUser(UserVo vo) {
		String email = vo.getEmail();
		String result = mypageRepository.lookUpPassword(email);
		
		if(!result.equals(vo.getPassword())) {
			return 0;
		}
		
		mypageRepository.foreignKeyChecks(0L);
		int deleteUser = mypageRepository.deleteUser(vo);
		mypageRepository.foreignKeyChecks(1L);
		
		return deleteUser;
	}

	public int deleteProblem(Long no) {
		return mypageRepository.deleteProblem(no);
	}

	public List<SubmitVo> problemSolveList(Long no) {
		return mypageRepository.problemSolveList(no);
	}

	public Map<String, Object> getContentsList(int currentPage, Long userNo, String keyword, Boolean mailChecked) {
		//게시물 총 갯수
		int count = mypageRepository.getTotalCount(userNo, keyword, mailChecked);
		//하단 페이징 번호([게시물 총 갯수 / 한 페이지에 출력할 갯수]의 올림)
		int pageNum = (int)Math.ceil((double)count/postNum);
		//출력할 게시물
		int displayPost = (currentPage -1) * postNum;
		//표시되는 페이지 번호 중 마지막 번호
		int endPageNum = (int)(Math.ceil((double)currentPage / (double)pageNum_cnt) * pageNum_cnt);
		//표시되는 페이지 번호 중 첫번째 번호
		int startPageNum = endPageNum - (pageNum_cnt - 1);
		//마지막번호 재계산
		int endPageNum_tmp = (int)(Math.ceil((double)count / (double)postNum));
		if(endPageNum > endPageNum_tmp) {
			endPageNum = endPageNum_tmp;
		}
		boolean next = endPageNum * pageNum_cnt >= count ? false : true;//마지막 페이지 번호가 총 게시물 갯수보다 작다면, 다음 구간이 있다는 의미이므로 출력		
		
		List<ProblemVo> list = mypageRepository.selectProblemList(displayPost, postNum, userNo, keyword, mailChecked);
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("list",list);		
		map.put("pageNum",pageNum);
		map.put("select",currentPage);
		map.put("startPageNum",startPageNum);
		map.put("endPageNum", endPageNum + 1);
		map.put("next",next);
		map.put("count", count);
		
		return map;
	}

	public List<SubProblemVo> findSubProblem(Long no) {
		return mypageRepository.findSubProblem(no);
	}

	public int deleteSubProblem(Long no) {
		return mypageRepository.deleteSubProblem(no);
	}

	public List<SubmitVo> findRrightSubmit(Long no) {
		return mypageRepository.findRrightSubmit(no);
	}

	public List<SubmitVo> findWrongSubmit(Long no) {
		return mypageRepository.findWrongSubmit(no);
	}

	public void privacyChange(Long authUserNo, String privacy) {
		if("open".equals(privacy)) {
			privacy = "y";
		} else {
			privacy = "n";
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("privacy", privacy);
		map.put("authUserNo", authUserNo);
		
		mypageRepository.privacyChange(map);
	}

	public Long findSaveNoByProblemNoAndUserNo(Long problemNo, Long userNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("problemNo",problemNo);
		map.put("userNo",userNo);
		return mypageRepository.findSaveNoByProblemNoAndUserNo(map);
	}

	public UserVo findWriterByProblemNo(Long problemNo) {
		return mypageRepository.findWriterByProblemNo(problemNo);
	}

	public Long selectRank(Long authUserNo) {
		return mypageRepository.selectRank(authUserNo);
	}

	public String sendMail(String[] email, ProblemVo problemVo) {
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			messageHelper.setText("코딩테스트 제목 : " + problemVo.getTitle() + "\n\n" + "인증번호 : " + problemVo.getPassword() + "\n\n" + 
					"사이트의 Coding Test 탭에서 입장 가능하고, 최초 입장 시 이름, 생년월일, 인증번호를 입력하셔야 합니다.\n\n" + "http://192.168.0.141:8080/codeforest/" + "\n\n" + "위 링크를 클릭하시면 사이트로 이동합니다.");
			messageHelper.setFrom("codeforest2020@gmail.com","코드의숲");
			messageHelper.setSubject("[Code Forest] 코딩 테스트 인증번호입니다");
			
			String mailPlus = "";
			for(int i = 0; i < email.length; i++) {
				mailPlus += email[i];
				if(i < email.length - 1) {
					mailPlus += ", ";
				}
			}
			messageHelper.setTo(InternetAddress.parse(mailPlus));
			mailSender.send(message);
		}catch(Exception e) {
			System.out.println(e);
		}
		return "success";
	}

	public ProblemVo getProblemPasswordAndTitle(Long problemNo) {
		return mypageRepository.getProblemPasswordAndTitle(problemNo);
	}
}