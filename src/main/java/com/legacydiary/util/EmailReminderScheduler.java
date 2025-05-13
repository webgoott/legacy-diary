package com.legacydiary.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.legacydiary.domain.DiaryVO;
import com.legacydiary.mapper.DiaryMapper;
import com.legacydiary.persistence.MemberDAO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class EmailReminderScheduler {

	private final DiaryMapper diaryMapper;
	private final MemberDAO memberDAO;
	private final SendMailService sendMailService;

	@Scheduled(cron = "0 10 11 * * *") 
	public void reminderShedule() throws AddressException, FileNotFoundException, MessagingException, IOException {
		// 내일 마감인 글 조회
		List<DiaryVO> list = diaryMapper.selectDiaryDueTomorrow();
		log.info("list : {} ", list);

		// key : writer
		// value: 내일 마감인 글 list
		Map<String, List<DiaryVO>> memberDiaryMap = new HashMap<>();

		for (DiaryVO vo : list) {

			if (!memberDiaryMap.containsKey(vo.getWriter())) {
				memberDiaryMap.put(vo.getWriter(), new ArrayList<DiaryVO>());
			}

			memberDiaryMap.get(vo.getWriter()).add(vo);
		}

		for (Map.Entry<String, List<DiaryVO>> entry : memberDiaryMap.entrySet()) {
			String memberId = entry.getKey();
			log.info("writer : {} ", memberId);
			log.info("list : {} ", entry.getValue());

			String email = memberDAO.selectEmailByMemberId(memberId);
			log.info("email : {}", email);

			// 메일 본문
			StringBuilder sb = new StringBuilder();

			sb.append("안녕하세요. 내일까지 해야할 일이 있습니다.");

			for (DiaryVO vo : entry.getValue()) {
				sb.append("---").append(vo.getTitle());
			}

			sb.append(memberId + "님, 꼭 완료하세요!!!");
			log.info("내용 :  {} ", sb.toString());
			
			sendMailService.sendReminder(email, sb.toString());
			
		}

	}

}
