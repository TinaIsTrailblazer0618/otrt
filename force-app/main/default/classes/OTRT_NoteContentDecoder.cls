public with sharing class OTRT_NoteContentDecoder {
    @AuraEnabled
	public static String decodeNoteContent(String noteId) {
        List<ContentNote> queryNote = [SELECT Content FROM ContentNote WHERE Id = :noteId LIMIT 1];
        String contentString = queryNote[0].Content.toString();
        return contentString;
    }
}