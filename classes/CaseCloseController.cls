/**
 * @File Name          : CaseCloseController.cls
 * @Description        : 
 * @Author             : Abhimanyu Tanwar
 * @Group              : 
 * @Last Modified By   : Abhimanyu Tanwar
 * @Last Modified On   : 4/30/2019, 12:44:54 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/29/2019, 11:17:22 PM   Abhimanyu Tanwar     Initial Version
**/
public with sharing class CaseCloseController {
    /**
    * @description : return case Closed Status
    * @author Abhimanyu Tanwar 
    * @return Map<String, String>
    */
    @auraEnabled
    public static Map<String,String> getCloseCaseStatus() {
        Map<String,String> statusMap = new Map<String,String>();
        for(CaseStatus cs : [Select Id, MasterLabel,ApiName From CaseStatus Where IsClosed = true]) {
            statusMap.put(cs.MasterLabel,cs.ApiName);
        }
        return statusMap;        
    }
    
    /**
    * @description : Close Case and create Case comment
    * @author Abhimanyu Tanwar
    * @param String recordId
    * @param String caseStatus
    * @param String caseCommentBody
    * @return void
    */
    @auraEnabled
    public static void closeCaseRecord(String recordId, String caseStatus, String caseCommentBody) {
         try{             
            Case objCase = new Case(Id = recordId);
            objCase.status = caseStatus;
            update objCase;

            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = true;

            CaseComment cs = new CaseComment();
            cs.parentId = objCase.Id;
            cs.Commentbody = caseCommentBody;
            Database.insert(cs,dlo);
         }catch(Exception e ){
            System.debug(e.getMessage() + ' | Line Number :'+e.getLineNumber()+' | Record ID :'+recordId);
            throw new AuraHandledException(e.getMessage());
        }
    }
}