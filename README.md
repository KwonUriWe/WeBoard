# WeBoard
## Jsp, Oracle, Tomcat을 활용한 회원제 게시판 사이트

### 메인화면

#### index
- Index와 GNB는 자주 수정될 수 있기 때문에 수월한 관리를 위해 별도의 파일을 작성한 후 호출해 사용하도록 한다.
- 로그인 여부 및 로그인된 계정에 따라 GNB의 버튼 내용이 달라지도록 한다.
  - 비 로그인
  ![K-001](https://user-images.githubusercontent.com/59382990/82868520-bb3ce700-9f67-11ea-86b5-d89a7ba690c9.jpg)
  - 관리자 계정으로 로그인
  ![K-002](https://user-images.githubusercontent.com/59382990/82868521-bc6e1400-9f67-11ea-87de-38660a1278d6.jpg)
  - 일반 회원(we) 계정으로 로그인
  ![K-003](https://user-images.githubusercontent.com/59382990/82868523-bd06aa80-9f67-11ea-974c-9b720c4bc978.jpg)
  
### 회원 관리
  
#### 계정 관리 화면
- 로그인 후 진입이 가능하다.
- 로그인된 계정에 따라 Contents에 표시되는 버튼이 달라지도록 한다.
  - 관리자 계정으로 로그인
  ![K-004](https://user-images.githubusercontent.com/59382990/82869255-e6740600-9f68-11ea-9904-0e32d5a1114b.jpg)
  - 일반 회원(we) 계정으로 로그인
  ![K-005](https://user-images.githubusercontent.com/59382990/82869260-e83dc980-9f68-11ea-818d-65987c283771.jpg)

#### 로그인
- 비 로그인 상태에서만 진입이 가능하다.
- Form에서 아이디와 비밀번호를 입력한 뒤 로그인 버튼 또는 엔터키를 누르면 Pro에서 DB의 Usr테이블에 접속하여 일치 여부를 확인한다.
- 일치할 경우 세션에 아이디 정보를 저장한다.
- 일치하는 아이디 또는 비밀번호가 없을 경우, 탈퇴한 계정일 경우, DB 연결에 실패할 경우 팝업으로 알린다.
  ![login](https://user-images.githubusercontent.com/59382990/82866198-66976d00-9f63-11ea-8658-0ba171b8db18.jpg)

#### 로그아웃
- 로그인 후 진입 가능하다.
- 별도의 폼이나 확인절차 없이 버튼 클릭 시 바로 세션에 저장된 정보를 삭제한다.
  ![logout](https://user-images.githubusercontent.com/59382990/82866250-7d3dc400-9f63-11ea-8ddb-1f804efef026.jpg)

#### 회원가입
- 비 로그인 상태에서만 진입이 가능하다.
- 폼에서 모든 값을 입력한 후 회원가입 버튼 또는 엔터키를 누르면 Pro에서 DB의 Usr테이블에 접속하여 아이디의 중복 여부를 확인한 후 중복이 없을 경우 회원정보를 저장한다.
- 입력하는 값에 빈 칸이 없어야 하며, 비밀번호와 재확인 비밀번호가 같아야 한다.
- 만약 중복되는 아이디 값이 있을 경우 팝업으로 알린다.
  ![join](https://user-images.githubusercontent.com/59382990/82866265-875fc280-9f63-11ea-944a-e0eb603269d2.jpg)

#### 회원 비밀번호 확인
- 회원 정보 수정 또는 회원 탈퇴 전에 회원 확인을 위해 거쳐가는 화면이다.
- Form으로 이동시 로그인 되어있는 아이디 값은 입력창에 자동으로 입력된다.
- 비밀번호 입력 후 확인 버튼 또는 엔터키를 누르면 Pro에서 DB의 Usr테이블에 접속하여 아이디에 대한 비밀번호가 올바른지 확인 후 수정 화면으로 이동 또는 탈퇴 처리한다.
  - 수정 전 비밀번호 확인
  ![check1](https://user-images.githubusercontent.com/59382990/82866284-90509400-9f63-11ea-830d-380a0bd623d0.jpg)
  - 탈퇴 전 비밀번호 확인
  ![check2](https://user-images.githubusercontent.com/59382990/82866289-921a5780-9f63-11ea-9c33-0f2e5dbbd90a.jpg)

#### 회원 정보 수정
- 로그인 후 usrCheckPro.jsp를 거쳐서 진입 가능하다.
- 회원 정보 수정 시 아이디는 수정 불가하다.
- 각 입력 화면에 기존에 저장된 비밀번호를 제외한 회원의 정보가 자동으로 입력된다.
- 모든 정보가 입력된 후 정보 수정 버튼 또는 엔터키를 누르면 Pro에서 DB의 Usr테이블에 접속하여 아이디에 대한 각 정보들을 저장한다.
- 입력하는 값에 빈 칸이 없어야 하며, 비밀번호와 재확인 비밀번호가 같아야 한다.
  ![update](https://user-images.githubusercontent.com/59382990/82866309-9cd4ec80-9f63-11ea-8c71-e04f6505bd0f.jpg)

#### 회원 탈퇴
- 별도의 jsp파일 없이 usrCheckPro.jsp에서 usrDAO의 메소드만 호출한다.
- 탈퇴시점을 기준으로 한 달 후에 정보가 삭제되므로 탈퇴여부와 탈퇴시점을 함께 저장해야 한다.
- 탈퇴 후 usrLogoutPro.jsp로 이동하여 로그아웃 처리 된다.
  ![delete](https://user-images.githubusercontent.com/59382990/82866325-a4949100-9f63-11ea-82a5-09b28aad501b.jpg)

#### 회원 목록 조회
- 관리자 계정으로 로그인 한 후에만 진입이 가능하다.
- 한 페이지 당 10명의 회원이 표시 되도록 페이징 처리하며, 탈퇴회원이 가장 먼저 보이도록 함. 그 다음은 가입 또는 탈퇴일의 내림차순으로 정렬한다.
- 탈퇴 여부는 숫자 대신 사용중 회원, 탈퇴 회원으로 표시한다.
- 아이디와 이메일로 회원 검색이 가능하다.
- 저장된 회원이 없을 경우 해당 내용을 안내한다.
  ![list](https://user-images.githubusercontent.com/59382990/82866346-ac543580-9f63-11ea-8fd7-dbe649bc15c8.jpg)

#### 회원 정보 삭제
- 관리자 계정으로 로그인 한 후에만 진입이 가능하다.
- 별도의 Form 없이 usrList.jsp 하단에 위치한 버튼을 클릭 시 탈퇴 회원 중 탈퇴한지 한 달 이상 된 회원의 정보만 삭제한다.
  ![delFinal](https://user-images.githubusercontent.com/59382990/82866367-b413da00-9f63-11ea-8dbf-28d788329939.jpg)

### 게시글 관리

#### 게시판 목록 조회
- 비 로그인 상태에서도 진입이 가능하나, 글 쓰기 버튼 클릭 시 로그인이 필요하다는 안내 팝업 후 로그인 화면으로 이동한다.
- 한 페이지 당 표시할 글의 수를 회원이 선택 가능하도록 한다.
- 제목+내용, 제목, 내용, 작성자로 게시글 검색이 가능하다.
- 목록의 글 제목을 클릭 시 해당 글의 조회 화면으로 이동한다.
- 목록의 작성자 클릭시 작성자 아이디 아래로 게시글 보기와 이메일 보내기 탭이 생성되며 클릭 시 각각의 기능을 수행한다.
- 저장된 글이 없을 경우 해당 내용을 안내한다.
  - 페이지처리, 작성자 클릭
  ![list1](https://user-images.githubusercontent.com/59382990/82866563-21c00600-9f64-11ea-89f4-97df42122f59.jpg)
  - 저장된 글 없음
  ![list2](https://user-images.githubusercontent.com/59382990/82866566-22f13300-9f64-11ea-998b-27574710dea5.jpg)

#### 게시글 작성
- 로그인 후에만 진입이 가능하다.
- 작성 항목은 제목, 내용, 업로드할 파일이며 그 중 제목과 내용은 필수 입력 항목이다.
- 글 저장하면 자동으로 작성자에 로그인한 아이디가 입력된다.
  - 일반 회원 / 글 작성
  ![write1](https://user-images.githubusercontent.com/59382990/82866473-f3422b00-9f63-11ea-939d-e6fe9fc2fa62.jpg)
  - 관리자 / 공지글 작성
  ![write2](https://user-images.githubusercontent.com/59382990/82866485-f806df00-9f63-11ea-9a2f-312a08599a0d.jpg)
  - 관리자 / 일반글 작성
  ![write3](https://user-images.githubusercontent.com/59382990/82866487-f9380c00-9f63-11ea-9c91-6023d056556a.jpg)

#### 게시글 조회
- 비 로그인 상태에서도 진입이 가능하나, 답글 쓰기 버튼 클릭 시 로그인이 필요하다는 안내 팝업 후 로그인 화면으로 이동한다.
- 로그인 후 진입하여 답글 쓰기 버튼 클릭 시에는 글 작성 화면으로 이동한다.
- 만약, 로그인 한 아이디가 조회한 글의 작성자와 동일할 경우 수정, 삭제 버튼이 추가로 표시되며 클릭 시 각각의 기능을 수행한다.
  - 관리자 / 공지사항 조회
  ![view1](https://user-images.githubusercontent.com/59382990/82866513-0654fb00-9f64-11ea-935b-20e0edfa3e5d.jpg)
  - 일반 회원 / 공지사항 조회
  ![view2](https://user-images.githubusercontent.com/59382990/82866516-06ed9180-9f64-11ea-807a-ef126753d678.jpg)
  - 관리자 / 타인의 일반글 조회
  ![vew4](https://user-images.githubusercontent.com/59382990/82866521-08b75500-9f64-11ea-974c-80ae2388f50e.jpg)
  - 일반회원 / 본인 글 조회
  ![view3](https://user-images.githubusercontent.com/59382990/82866519-07862800-9f64-11ea-865c-39723cf68767.jpg)
  

#### 게시글 수정
- 게시글 조회 화면에서 표시된 버튼 클릭 시 진입 된다.
- 각 항목에 기존에 저장된 정보가 자동으로 입력되며, 글 작성 시와 마찬가지로 제목과 내용에는 공백이 없어야 한다.
- 기 업로드 된 파일이 있을 경우 파일 업로드 선택 칸 우측에 해당 파일의 이름을 표시한다.
  ![update](https://user-images.githubusercontent.com/59382990/82866535-11a82680-9f64-11ea-9769-aebda337d523.jpg)

#### 게시글 삭제
- 게시글 조회 화면에서 표시된 버튼 클릭 시 화면 이동 없이 안내 팝업 후 삭제된다.
  ![delete](https://user-images.githubusercontent.com/59382990/82866551-18cf3480-9f64-11ea-8828-7c936353a33d.jpg)

### 추후 개선해야 할 사항
- 게시글 삭제 시 팝업 창에 취소버튼을 추가하여 확인 클릭 시에만 게시글이 삭제되고 취소를 클릭할 경우 처리되지 않도록 한다.
- 회원이 탈퇴를 하지 않더라도 관리자의 권한으로 계정을 삭제할 수 있도록 한다.
- 회원이 본인이 작성한 글을 삭제하지 않더라도 관리자의 권한으로 부적합하다 판단된 게시글을 삭제할 수 있도록 한다.
- 관리자가 작성한 글 수정 시 공지 글 또는 일반 글로 변경 여부를 선택할 수 있도록 한다.
