% -*- TeX:UTF-8 -*-
%% KU Thesis Template for LaTeX
%%
%%       Author: Genie Jhang ( geniejhang@majimak.com )
%%         Date: 2013. 08. 11
%%
%% Requirements: TeXLive + ko.TeX
%%
%%    Reference: KAIST Thesis Templete for LaTeX version 0.4

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{KUThesis}

%% 옵션 선언을 위한 변수 선언
\newif\if@isDoctor
\newif\if@isDraft
\newif\if@pdfdoc

%% 새 옵션 모음 - doctor|master, final|draft
\DeclareOption{doctor}       {\@isDoctortrue}
\DeclareOption{master}       {\@isDoctorfalse}
\DeclareOption{final}        {\@isDraftfalse}
\DeclareOption{draft}        {\@isDrafttrue}
\DeclareOption{pdfdoc}       {\@pdfdoctrue}

%% leqno,fleqn,openbib 옵션은 그대로 report 클래스에 전달
\DeclareOption{leqno}  {\PassOptionsToClass{leqno}  {report}}
\DeclareOption{fleqn}  {\PassOptionsToClass{fleqn}  {report}}
\DeclareOption{openbib}{\PassOptionsToClass{openbib}{report}}

\ExecuteOptions{doctor,draft}         % doctor,draft가 기본값
\ProcessOptions

%% 11pt,onecolumn,oneside 옵션으로 report 클래스 불러오기
\LoadClass[11pt,onecolumn,oneside]{report}

%% bibliography
\usepackage[square,comma,sort&compress,longnamesfirst]{natbib}

%% 들여쓰기
\usepackage{indentfirst}
\setlength\parindent{2.0em}

\RequirePackage{ifthen}       % 추가 패키지 설정
\RequirePackage{graphicx,xcolor}
\RequirePackage[cjk]{kotex}

%% PDF 파일로 문서를 만들었을 때 링크 활성화
\if@pdfdoc
  \RequirePackage[unicode,%
      pdftex=true,%
      bookmarks=true,%
     colorlinks=true,%
   ]{hyperref}
\else
  \RequirePackage[unicode,%
      pdftex=true,%
      bookmarks=false,%
     colorlinks=false,%
   ]{hyperref}
\fi

\AtBeginDocument{%                           % \begin{document}와 함께 실행
    \checkparameters                         % 문서 변수가 올바른지 점검
    \makefrontcover \maketitle               % 앞표지, 속표지 생성
    \if@isDraft                              % final 옵션이 지정되어 있으면
    \else
      \makeapproval                          % 제출승인서, 심사완료검인 생성
    \fi 
    \makeabstract                            % 초록 페이지 생성
    \makecontents
}
\AtEndDocument{                             % \end{document}와 함께 실행
  \makeacknowledgement
}

%% 편집용지 설정 - 좀 바꿔야 할 듯 나중에
%\usepackage[left=34.0mm,right=34.0mm,top=45mm,bottom=45mm,a4paper]{geometry}
\usepackage[left=25.0mm,right=15.0mm,top=30mm,bottom=30mm,paperwidth=182mm,paperheight=257mm]{geometry}
%\setlength{\pdfpagewidth}{182mm}
%\setlength{\pdfpageheight}{257mm}

%% 줄간격 설정
\linespread{1.3}

%% 고려대학교 공식 영문명칭
\newcommand{\@koreauniv}{Korea University}

%% pagestyle 
%\def\ps@koreauniv{\let\@mkboth\@gobbletwo
%     \let\@oddhead\@empty
%     \def\@oddfoot{\reset@font\hfil--\ \thepage\ --
%     \hfil}%
%     \let\@evenhead\@empty\let\@evenfoot\@oddfoot
%}

%\pagestyle{koreauniv}

% @command title 논문 제목
\renewcommand{\title}[1] {%
\newcommand{\@titleEng}{#1}{}%
}
\@onlypreamble{\title}

% @command author 저자 이름
% @param family_name, given_name 성, 이름을 구분해서 입력
% @options [default: (none)]
% - korean: 한글이름 | chinese: 한문이름 | english: 영문이름
\renewcommand{\author}[4][chinese] {%
    \ifthenelse{\equal{#1}{chinese}}
        {\newcommand{\@authorChnF}{#2}
         \newcommand{\@authorChnS}{#3}
         \newcommand{\@authorChnT}{#4}
         \ifthenelse{\equal{#4}{}}{
           \newcommand{\@authorChn}{#2#3}
         }{
           \newcommand{\@authorChn}{#2#3#4}
         }{}%
         \ifthenelse{\equal{#4}{}}{
           \newcommand{\@authorChnSpace}{#2\ #3}
         }{
           \newcommand{\@authorChnSpace}{#2\ #3\ #4}
         }}{}%
    \ifthenelse{\equal{#1}{english}}
        {\newcommand{\@authorEngFN}{#2}
         \newcommand{\@authorEngGN}{#3}
         \ifthenelse{\equal{#4}{}}{
           \newcommand{\@authorEng}{#3\ #2}
         }{
           \newcommand{\@authorEng}{#3\ #4\ #2}
         }}{}%
}
\@onlypreamble{\author}

% @command advisor 지도교수 이름 (복수가능)
% @options [default: major]
% - major: 주 지도교수  | coopr: 부 지도교수 (공동지도교수 경우)
\newcommand{\advisor}[2]{%
  \newcommand{\@advisorMajorChn}{#1}  % 영문이름 저장
  \newcommand{\@advisorMajorEng}{#2}  % 영문이름 저장
}
\@onlypreamble{\advisor}

\if@isDoctor
  \newcommand{\@degreeChn}{博}
  \newcommand{\@degreeEng}{Doctor}
\else
  \newcommand{\@degreeChn}{碩}
  \newcommand{\@degreeEng}{Master}
\fi

% @command department 
%
\newcommand{\department}[2] {%
    \ifthenelse{\equal{#1}{PH}}
        {\newcommand{\@deptNameEng}{Physics}
         \newcommand{\@deptNameEngFull}{Department of Physics}
         \newcommand{\@deptNameChn}{物\ 理\ 學\ 科}} {}
}
\@onlypreamble{\department}

% @command referee 심사위원 (석사과정 3인, 박사과정 5인)
\newcommand{\referee}[2][1] {%
    \ifthenelse{\equal{#1}{1}}{\newcommand{\@refereeChief} {#2}} {}%
    \ifthenelse{\equal{#1}{2}}{\newcommand{\@refereeSecond}{#2}} {}%
    \ifthenelse{\equal{#1}{3}}{\newcommand{\@refereeThird} {#2}} {}%
    \ifthenelse{\equal{#1}{4}}{\newcommand{\@refereeFourth}{#2}} {}%
    \ifthenelse{\equal{#1}{5}}{\newcommand{\@refereeFifth} {#2}} {}%
}
\@onlypreamble{\referee}

% @command approvaldate 지도교수논문승인일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\approvaldate}[3] {%
    \newcommand{\@approvalYear}{#1}
    \newcommand{\@approvalMonth}{#2}
    \newcommand{\@approvalDay}{#3}
}
\@onlypreamble{\approvaldate}

% @command refereedate 심사위원논문심사일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\refereedate}[3] {%
    \newcommand{\@refereeYear}{#1}
    \newcommand{\@refereeMonth}{#2}
    \newcommand{\@refereeDay}{#3}
}
\@onlypreamble{\refereedate}

% @command gradyear 졸업년도
\newcommand{\graduateDate}[2]{
  \newcommand{\@graduateYear}{#1}
  \newcommand{\@graduateMonth}{#2}
}
\@onlypreamble{\graduateDate}

% @command subdate 제출일자
\newcommand{\submitDate}[3]{
  \newcommand{\@submitYear}{#1}
  \newcommand{\@submitMonth}{#2}
  \newcommand{\@submitDay}{#3}
}
\@onlypreamble{\submitDate}

% @command abstract 초록
\newcommand{\abstractContents}[1]{
  \newcommand{\@abstractContents}{#1}
}
\@onlypreamble{\abstractContents}

% @command acknowledge 감사의 글
\newcommand{\acknowledgementContents}[1]{
  \newcommand{\@acknowledgementContents}{#1}
}
\@onlypreamble{\acknowledgementContents}

%%
%% 필요한 정보 중에 누락된 것이 없는지 점검 --> 제작중. 아직 불완전.
%%
\newcommand{\checkparameters}{%
    \@ifundefined{@titleEng}{%
        \ClassError{KUThesis}{The english title is not found}{}}{}
    \@ifundefined{@authorChn}{%
        \ClassError{KUThesis}{The chinese name of the author is not found}{}}{}
    \@ifundefined{@authorEng}{%
        \ClassError{KUThesis}{The english name of the author is not found}{}}{}
    \@ifundefined{@advisorMajorEng}{%
        \ClassError{KUThesis}{The english name of the major advisor is not found}{}}{}
    \@ifundefined{@advisorMajorChn}{%
        \ClassError{KUThesis}{The chinese name of the major advisor is not found}{}}{}
}

%%
%% 영문 날짜 표기
%%
\newcommand{\@dateUSenglish}[2]{%  % 미국식 날짜 표기
    \newcommand{\@year}{#1}%
    \newcommand{\@month}{#2}%
    \ifcase\@month \or
        January \or February \or March \or April \or May \or June \or
        July \or August \or September \or October \or November \or December \fi
    \@year
}

%%
%% 빈 페이지 생성
%%
\newcommand{\emptypage}{
  \newpage
  \thispagestyle{empty}
  \mbox{ }
  \newpage
}

%%
%% 앞표지 생성
%%
\newcommand{\makefrontcover}{%
    \newpage
    \renewcommand{\baselinestretch}{1.3}%
    \thispagestyle{empty} \noindent%
    \hspace{15mm}\begin{minipage}[t][12mm][t]{112mm}
        \begin{center}
            \fontsize{16pt}{16pt}\selectfont\bf{Thesis for the Degree\\of \@degreeEng}
        \end{center}
    \end{minipage}\\[30mm] \noindent
    \hspace*{15mm}\begin{minipage}[t][50mm][t]{112mm}
        \begin{center}
            \fontsize{21pt}{21pt}\selectfont{\bf \@titleEng}
        \end{center}
    \end{minipage}\vfill \noindent
    \hspace{15mm}\begin{minipage}[b][85mm][b]{112mm}
        \begin{center}
            \fontsize{16pt}{16pt}\selectfont{\bf by}
            \\[5mm]
            \fontsize{16pt}{16pt}\selectfont{\bf \@authorEng}
            \\[5mm]
            \fontsize{16pt}{16pt}\selectfont{\bf \@deptNameEngFull}
            \\[15mm]
            \fontsize{18pt}{18pt}\selectfont{\bf Graduate School}
            \\[5mm]
            \fontsize{18pt}{18pt}\selectfont{\bf \@koreauniv}
            \\[10mm]
            \fontsize{16pt}{16pt}\selectfont{\bf
            \@dateUSenglish{\@graduateYear}{\@graduateMonth}}
        \end{center}
    \end{minipage}
    \newpage
}

%%
%% 속표지 생성
%%
\renewcommand{\maketitle}{%
    \newpage
    \renewcommand{\baselinestretch}{1.3}%
    \thispagestyle{empty} \noindent
    \hspace{15mm}\begin{minipage}[t][16pt][t]{112mm}
      \begin{center}
        \fontsize{16pt}{16pt}\selectfont\bf{\@advisorMajorChn\ 敎授指導}
        \\[5mm]
        \fontsize{16pt}{16pt}\selectfont\bf{\@degreeChn\ 士\ 學\ 位\ 論\ 文}
        \\[30mm]
        \fontsize{21pt}{21pt}\selectfont{\bf \@titleEng}
      \end{center}
    \end{minipage}\vfill \noindent
    \hspace{15mm}\begin{minipage}[b][110mm][b]{112mm}
      \begin{center}
        \fontsize{16pt}{16pt}\selectfont{\bf 이 論文을 物理學 \@degreeChn士學位 論文으로 提出함}
        \\[30mm]
        \fontsize{14pt}{14pt}\selectfont{\bf \@submitYear年\ \@submitMonth月\ \@submitDay日}
        \\[30mm]
        \fontsize{18pt}{18pt}\selectfont{\bf 高\ 麗\ 大\ 學\ 交\ 大\ 學\ 院}
        \\[5mm]
        \fontsize{16pt}{16pt}\selectfont{\bf \@deptNameChn}
        \\[10mm]
        \fontsize{16pt}{16pt}\selectfont{\bf \@authorChnSpace}
        \fontsize{14pt}{14pt}\selectfont{\bf \hspace{10mm} (印)}
      \end{center}
    \end{minipage}
    \newpage
}

\usepackage{soul}
\sodef\spaceout{}{0pt plus 1fil}{.4em plus 1fil}{0pt}

%%
%% 학위논문 심사완료 검인서 생성
%%
\newcommand{\makeapproval}{%
  \newpage
  \thispagestyle{empty} \noindent%
  \renewcommand{\baselinestretch}{1.3}
  \\[10mm]
  \hspace*{15mm}\begin{minipage}[t][20mm][t]{112mm}
    \begin{center}
      \fontsize{15.5pt}{15.5pt}\selectfont{\bf \@authorChn의 物理學 \@degreeChn士學位論文 審査를 完了함}
      \\[30mm]
      \fontsize{14pt}{14pt}\selectfont{\bf \@submitYear年\ \@submitMonth月\ \@submitDay日}
      \\[20mm]
      \underline{
        \fontsize{16pt}{16pt}\selectfont{\bf 委員長}
        \fontsize{14pt}{14pt}\selectfont{\hspace{60mm}\bf (印)}
      }
      \\[10mm]
      \underline{
        \fontsize{16pt}{16pt}\selectfont{\bf 委　員}
        \fontsize{14pt}{14pt}\selectfont{\hspace{60mm}\bf (印)}
      }
      \\[10mm]
      \underline{
        \fontsize{16pt}{16pt}\selectfont{\bf 委　員}
        \fontsize{14pt}{14pt}\selectfont{\hspace{60mm}\bf (印)}
      }
      \if@isDoctor
        \\[10mm]
        \underline{
          \fontsize{16pt}{16pt}\selectfont{\bf 委　員}
          \fontsize{14pt}{14pt}\selectfont{\hspace{60mm}\bf (印)}
        }
        \\[10mm]
        \underline{
          \fontsize{16pt}{16pt}\selectfont{\bf 委　員}
          \fontsize{14pt}{14pt}\selectfont{\hspace{60mm}\bf (印)}
        }
      \else\fi
    \end{center}
  \end{minipage}
  \newpage
}

%%
%% 초록 페이지 생성
%%
\newcommand{\makeabstract}[1]{%
  \newpage
  \thispagestyle{empty} \noindent
  \begin{minipage}[t][202mm][c]{\textwidth}
    \begin{center}
      \fontsize{16pt}{16pt}\selectfont{\bf Abstract}
    \end{center}

    \linespread{1.3}
    \setlength\parindent{2.0em}
    \fontsize{11pt}{11pt}\selectfont{\indent\@abstractContents}
  \end{minipage}
  \newpage
}

%%
%% 목차 일괄 생성
%%
\newcommand{\makecontents}{%            % TOC, LOT, LOF 생성
  \tableofcontents
  \listoftables
  \listoffigures
}

%%
%% 감사의 글 페이지 생성
%%
\newcommand{\makeacknowledgement}[1]{%
  \newpage
  \thispagestyle{empty} \noindent
  \begin{minipage}[t][202mm][c]{\textwidth}
    \begin{center}
      \fontsize{16pt}{16pt}\selectfont{\bf Acknowledgement}
    \end{center}

    \linespread{1.3}
    \setlength\parindent{2.0em}
    \fontsize{11pt}{11pt}\selectfont{\indent\@acknowledgementContents}
  \end{minipage}
  \newpage
}
