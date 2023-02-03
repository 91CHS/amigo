package com.lec.amigo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.lec.amigo.chat.JDBCUtility.JDBCUtility;
import com.lec.amigo.common.PagingVO;
import com.lec.amigo.common.SearchVO;
import com.lec.amigo.mapper.SitterRowMapper;
import com.lec.amigo.mapper.UserRowMapper;
import com.lec.amigo.vo.BoardVO;
import com.lec.amigo.vo.SitterVO;
import com.lec.amigo.vo.UserVO;

@Repository("bookDAO")
public class BookDAO {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public int calMoney(int days, int time) {
		String sql = "select sit_price from sit_price where sit_time=1";
		int price = jdbcTemplate.queryForObject(sql, Integer.class);
		int calResult = days*time*price;
		System.out.println(calResult+"예상비용입니다");
		return calResult;
	}

	public List<SitterVO> getArroudSitter(String secondeAddr, PagingVO page) {
		
		System.out.println(secondeAddr);

		String sql = "select u.user_no, s.sit_no, s.sit_days, s.sit_time, s.sit_photo, s.sit_intro from user u,petsitter s"+ 
				" where u.user_no = s.user_no and u.user_type='S' and user_addr like ? limit ?,?";
		
		String sqlinput = "%"+secondeAddr+"%";
		//1 -> 0 
		//2 -> 10
		//3 ->
		// 1*10 -> 10 - 10 = 0;
		// 2*10 -> 20 - 10 = 10;
		int startSno = (page.getCurPage()*page.getRowSizePerPage())-page.getRowSizePerPage();	
		List<SitterVO> sitList = new ArrayList<SitterVO>();
		Connection conn = JDBCUtility.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, sqlinput);
			pstmt.setInt(2, startSno);
			pstmt.setInt(3, page.getRowSizePerPage());
			rs = pstmt.executeQuery();
			while(rs.next()) {
				SitterVO si = new SitterVO();
				si.setUser_no(rs.getInt("user_no"));
				si.setSit_days(rs.getString("sit_days"));
				si.setSit_no(rs.getInt("sit_no"));
				si.setSit_time(rs.getString("sit_time"));
				si.setSit_photo(rs.getString("sit_photo"));
				si.setSit_intro(rs.getString("sit_intro"));
				sitList.add(si);
				
				System.out.println(si.getSit_no()+"sit_no 확인용");
				
			}
		
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("해당한 결과가 없습니다!");
		}
	
		
		return sitList;
	}

	public List<UserVO> getArroundSitterNames(String secondeAddr) {
	
		String sqlinput = "%"+secondeAddr+"%";
		String sql = "select * from user where user_addr like ?";
		
		Object[] args = {sqlinput};
		
		List<UserVO> uList = new ArrayList<UserVO>();
		
		try {
			uList = jdbcTemplate.query(sql, args, new UserRowMapper());
			if(!uList.isEmpty()) {
				return uList;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}
	
	public int getTotalRowCount(String secondeAddr) {
		String sql = "select count(u.user_no) cno from user u,petsitter s"+ 
				" where u.user_no = s.user_no and u.user_type='S' and user_addr like ?";
		String sqlinput = "%"+secondeAddr+"%";
		Object[] args = {sqlinput};
		return jdbcTemplate.queryForObject(sql, args, Integer.class);
	}
	
	public int getCateRowCount () {
		
		return 0;
	}
	
	

	
	
}
