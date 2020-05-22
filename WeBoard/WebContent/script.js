//글 저장시 공백 거름
function writeSave(){
	var writeform = document.writeform;
	
	if(!writeform.bbsTitle.value){
		alert("제목을 입력하세요.");
		writeform.bbsTitle.focus();
		return false;
	}
	
	if(!writeform.bbsContent.value){
		alert("내용을 입력하세요.");
		writeform.bbsContent.focus();
		return false;
	}
};

 //id 저장
$(document).ready(function(){
	var userInputId = getCookie("userInputId");//저장된 쿠기값 가져오기
	$("input[name='usrId']").val(userInputId); 
	     
	if($("input[name='usrId']").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩
		$("#idSaveCheck").attr("checked", true); // 아이디 저장하기 체크되어있을 시, ID 저장하기를 체크 상태로 두기.
	}
	     
	$("#idSaveCheck").change(function(){ // 체크박스에 변화가 발생시
		if($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
			var userInputId = $("input[name='usrId']").val();
			setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
			}else{ // ID 저장하기 체크 해제 시,
			deleteCookie("userInputId");
		}
	});
	     
	// ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
	$("input[name='usrId']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
		if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
			var userInputId = $("input[name='usrId']").val();
			setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
		}
	});
});
 
function setCookie(cookieName, value, exdays){
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
	document.cookie = cookieName + "=" + cookieValue;
}
 
function deleteCookie(cookieName){
	var expireDate = new Date();
	expireDate.setDate(expireDate.getDate() - 1);
	document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}
 
function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if(start != -1){
		start += cookieName.length;
		var end = cookieData.indexOf(';', start);
		if(end == -1)end = cookieData.length;
		cookieValue = cookieData.substring(start, end);
	}
	return unescape(cookieValue);
}