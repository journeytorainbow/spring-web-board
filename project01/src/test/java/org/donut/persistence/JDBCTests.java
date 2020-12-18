package org.donut.persistence;

import static org.junit.Assert.fail;

import java.sql.*;

import org.junit.*;

import lombok.extern.log4j.*;

@Log4j
public class JDBCTests {
	static {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testConnection() {
		try(Connection con = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521:xe",
					"c##book_ex",
					"1234")) {
			log.info(con);
		} catch (Exception e) {
			fail(e.getMessage());
		}
	}
}