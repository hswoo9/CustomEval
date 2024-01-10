package com.duzon.custom.attachFile.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class AttachFileDAO extends AbstractDAO {

	public void fileUpload(Map<String, Object> map) {
		insert("attachFile.fileUpload", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getAttachFile(String fileKey) {
		return (Map<String, Object>) selectOne("attachFile.getAttachFile", fileKey);
	}

	
	
	
	
}
