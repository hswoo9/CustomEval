package com.duzon.custom.common.utiles;

import com.jcraft.jsch.*;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class CommFileUtil {
    private static final Logger logger = LoggerFactory.getLogger(CommFileUtil.class);

    private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"," "};

    //private String ADDRESS = "121.186.165.80";
    private String ADDRESS = "1.233.95.140";
    //private int PORT = 22;
    private int PORT = 51002;
    private String USERNAME = "root";
    //private String PASSWORD = "dev123!@#";
    private String PASSWORD = "epqmwlttn1q2w3e";
    private static Session session = null;
    private static Channel channel = null;
    private static ChannelSftp channelSftp = null;

    public CommFileUtil() throws Exception {
        init();
    }

    public void init() throws Exception {
        JSch jsch = new JSch();
        session = jsch.getSession(USERNAME, ADDRESS, PORT);
        session.setPassword(PASSWORD);

        java.util.Properties config = new java.util.Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);
        session.connect();
        channel = session.openChannel("sftp");
        channel.connect();

        channelSftp = (ChannelSftp) channel;
        boolean result = channelSftp.isConnected();  //접속여부를 리턴한다.(true/false)
        logger.info("접속여부 확인"+result);
    }

    public static void outputStream(HttpServletResponse response,FileInputStream in ) throws Exception {
        ServletOutputStream binaryOut = response.getOutputStream();
        byte buffer[] = new byte[8 * 1024];

        try {
            IOUtils.copy(in, binaryOut);
            binaryOut.flush();
        } catch ( Exception e ) {
        } finally {
            if (in != null) {
                try {
                    in.close();
                }catch(Exception e ) {}
            }
            if (binaryOut != null) {
                try {
                    binaryOut.close();
                }catch(Exception e ) {}
            }
        }
    }

    public Map<String, Object> setServerIFSave(String dir, byte[] imgByte, String fileName) {
        SftpATTRS attrs = null;

        String originFileExt  = "png"; // 원본 파일 확장자

        Map<String, Object> listMap = null;

        try {
            File lOutFile = File.createTempFile(fileName, "." + originFileExt);
            BufferedImage image = ImageIO.read(new ByteArrayInputStream(imgByte));
            ImageIO.write(image, "png", lOutFile);

            // 업로드할 파일이 있는지 체크
            if(imgByte.length > 0 && imgByte != null) {
                boolean isUpload = false;
                if(originFileExt != ""){
                    isUpload = true;
                }

                if(isUpload) {
                    String[] dirs = dir.split("/");
                    String serverPath = "";
                    for(int i = 0; i < dirs.length; i++){
                        if(dirs[i].equals("")) continue;
                        serverPath += "/" + dirs[i];
                        attrs = null;
                        try {
                            attrs = channelSftp.stat(serverPath);
                        }catch (Exception e){ }

                        if (attrs == null) {
                            channelSftp.mkdir(serverPath);
                        }
                    }

                    channelSftp.cd(dir);
                    channelSftp.put(new FileInputStream(lOutFile), fileName + "." + originFileExt);
                    lOutFile.delete();
                }
            }
            listMap = new HashMap<String, Object>();
            //listMap.put("signDir", "http:\\\\121.186.165.80:8010\\upload\\cust_eval\\" + fileName.replaceAll("_sign", "") + "\\sign\\" + fileName + ".png");
            listMap.put("signDir", "http:\\\\1.233.95.140:58090\\upload\\cust_eval\\" + fileName.replaceAll("_sign", "") + "\\sign\\" + fileName + ".png");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return listMap;
    }

    public void setServerSFSave(String fileStr, String dir, String fileName, String ext) {
        SftpATTRS attrs = null;

        String originFileName = fileName; // 원본파일이름
        String originFileExt  = ext; // 원본 파일 확장자

        try {
            File file = File.createTempFile(originFileName, "." + ext);
            FileOutputStream lFileOutputStream = new FileOutputStream(file);
            lFileOutputStream.write(fileStr.getBytes("UTF-8"));
            lFileOutputStream.close();

            if(fileStr != "" && fileStr.length() > 0 && fileStr != null) {
                boolean isUpload = false;
                if(originFileExt != ""){
                    isUpload = true;
                }

                if(isUpload) {
                    String serverFilePath = "/home/upload/cust_eval/" + dir + "/hwp";

                    try {
                        attrs = channelSftp.stat(serverFilePath);
                    }catch (Exception e){ }

                    if (attrs == null) {
                        channelSftp.mkdir(serverFilePath);
                    }

                    channelSftp.cd(serverFilePath);
                    channelSftp.put(new FileInputStream(file), originFileName + "." + originFileExt);
                    file.delete();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String setMakeZipFileDown(String zipDir, String returnZipDir, String compressedFileName) {
        for (int j = 0; j < invalidName.length; j++) {
            compressedFileName = compressedFileName.replaceAll(invalidName[j], "_");
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);
        byte[] buffer = new byte[1024];

        BufferedInputStream bis;
        try {
            Vector<ChannelSftp.LsEntry> filelist = channelSftp.ls(zipDir);
            channelSftp.cd(zipDir);
            for (ChannelSftp.LsEntry file : filelist) {
                if(file.getAttrs().isDir()) continue;
                ZipEntry ze = new ZipEntry(file.getFilename());
                zos.putNextEntry(ze);
                InputStream is = channelSftp.get(file.getFilename());
                buffer = new byte[1024];
                int length;
                while ((length = is.read(buffer)) > 0) {
                    zos.write(buffer, 0, length);
                }
                zos.closeEntry();
                is.close();
            }
            zos.close();
            byte[] zipBytes = baos.toByteArray();
            // 압축 파일 업로드
            InputStream zipInputStream = new ByteArrayInputStream(zipBytes);
            channelSftp.put(zipInputStream, compressedFileName);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnZipDir + "/" + compressedFileName;
    }
}
