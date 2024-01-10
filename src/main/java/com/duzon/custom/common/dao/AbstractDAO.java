package com.duzon.custom.common.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;

/**
 * 기본 DAO
 * @author iguns
 *
 */
public class AbstractDAO {
    protected Log log = LogFactory.getLog(AbstractDAO.class);
     
    @Resource(name="sqlSessionTemplate")  
    protected SqlSessionTemplate sqlSession;
    
    @Resource(name="sqlSessionTemplateMs")  
    protected SqlSessionTemplate sqlSessionMs;
    
    protected void printQueryId(String queryId) {
        if(log.isDebugEnabled()){
            log.debug("\t QueryId  \t:  " + queryId);
        }
    }
     
    public Object insert(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.insert(queryId, params);
    }
     
    public Object update(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.update(queryId, params);
    }
     
    public Object delete(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.delete(queryId, params);
    }
     
    public Object selectOne(String queryId){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId);
    }
     
    public Object selectOne(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId){
        printQueryId(queryId);
        return sqlSession.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectList(queryId,params);
    }
    
  //mssql
    public Object insertMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.insert(queryId, params);
    }
     
    public Object updateMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.update(queryId, params);
    }
     
    public Object deleteMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.delete(queryId, params);
    }
     
    public Object selectOneMs(String queryId){
        printQueryId(queryId);
        return sqlSessionMs.selectOne(queryId);
    }
     
    public Object selectOneMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs(String queryId){
        printQueryId(queryId);
        return sqlSessionMs.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.selectList(queryId,params);
    }
    
    
}
