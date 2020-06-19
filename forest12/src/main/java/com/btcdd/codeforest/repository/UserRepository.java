package com.btcdd.codeforest.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.vo.UserVo;

@Repository
public class UserRepository {
	
	@Autowired
	private SqlSession sqlSession;

	
	public int insert(UserVo vo) {
		return sqlSession.insert("user.insert", vo);
	}


	public UserVo findByEmailAndPassword(UserVo vo) {
		return sqlSession.selectOne("user.findByEmailAndPassword", vo);
	}


	public Long findByEmail(String email) {
		return sqlSession.selectOne("user.findByEmail", email);
	}


	public Object findNickname(String nickname) {
		return sqlSession.selectOne("user.findByNickname", nickname);
	}


	public int update(UserVo vo) {
		return sqlSession.update("user.updatePasswordAndEmail",vo);
	}


	public String findNicknameByEmail(String email) {
		return sqlSession.selectOne("user.findNicknameByEmail",email);
	}

}