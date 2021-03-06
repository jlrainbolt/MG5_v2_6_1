      SUBROUTINE MP_COMPUTE_LOOP_COEFS(PS,ANSDP)
C     
C     Generated by MadGraph5_aMC@NLO v. %(version)s, %(date)s
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Returns amplitude squared summed/avg over colors
C     and helicities for the point in phase space P(0:3,NEXTERNAL)
C     and external lines W(0:6,NEXTERNAL)
C     
C     Process: d d~ > t t~ QED=0 QCD=2 [ virt = QCD ] WEIGHTED=6
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      CHARACTER*64 PARAMFILENAME
      PARAMETER ( PARAMFILENAME='MadLoopParams.dat')
      INTEGER NBORNAMPS
      PARAMETER (NBORNAMPS=1)
      INTEGER    NLOOPS, NLOOPGROUPS, NCTAMPS
      PARAMETER (NLOOPS=14, NLOOPGROUPS=8, NCTAMPS=29)
      INTEGER    NCOLORROWS
      PARAMETER (NCOLORROWS=43)
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=4)
      INTEGER    NWAVEFUNCS,NLOOPWAVEFUNCS
      PARAMETER (NWAVEFUNCS=6,NLOOPWAVEFUNCS=32)
      INTEGER MAXLWFSIZE
      PARAMETER (MAXLWFSIZE=4)
      INTEGER LOOPMAXCOEFS, VERTEXMAXCOEFS
      PARAMETER (LOOPMAXCOEFS=15, VERTEXMAXCOEFS=5)
      INTEGER    NCOMB
      PARAMETER (NCOMB=16)
      REAL*16    ZERO
      PARAMETER (ZERO=0E0_16)
      COMPLEX*32 IMAG1
      PARAMETER (IMAG1=(0E0_16,1E0_16))
C     
C     ARGUMENTS 
C     
      REAL*16 PS(0:3,NEXTERNAL)
      REAL*8 ANSDP(3)
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,J,K,H,DUMMY
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
      REAL*16 P(0:3,NEXTERNAL)
      DATA IC/NEXTERNAL*1/
      REAL*16 ANS(3)
      COMPLEX*32 COEFS(MAXLWFSIZE,0:VERTEXMAXCOEFS-1,MAXLWFSIZE)
      COMPLEX*32 CFTOT
C     
C     GLOBAL VARIABLES
C     
      INCLUDE 'mp_coupl_same_name.inc'

      LOGICAL CHECKPHASE, HELDOUBLECHECKED
      COMMON/INIT/CHECKPHASE, HELDOUBLECHECKED

      INTEGER HELOFFSET
      INTEGER GOODHEL(NCOMB)
      LOGICAL GOODAMP(NLOOPGROUPS)
      COMMON/FILTERS/GOODAMP,GOODHEL,HELOFFSET

      INTEGER HELPICKED
      COMMON/HELCHOICE/HELPICKED

      COMPLEX*32 AMP(NBORNAMPS)
      COMMON/MP_AMPS/AMP
      COMPLEX*32 W(20,NWAVEFUNCS)
      COMMON/MP_W/W

      COMPLEX*16 DPW(20,NWAVEFUNCS)
      COMMON/W/DPW

      COMPLEX*32 WL(MAXLWFSIZE,0:LOOPMAXCOEFS-1,MAXLWFSIZE,0:NLOOPWAVEF
     $ UNCS)
      COMPLEX*32 PL(0:3,0:NLOOPWAVEFUNCS)
      COMMON/MP_WL/WL,PL

      COMPLEX*32 LOOPCOEFS(0:LOOPMAXCOEFS-1,NLOOPS)
      COMMON/MP_LCOEFS/LOOPCOEFS

      COMPLEX*32 AMPL(3,NCTAMPS)
      COMMON/MP_AMPL/AMPL

      INTEGER CF_D(NCOLORROWS,NBORNAMPS)
      INTEGER CF_N(NCOLORROWS,NBORNAMPS)
      COMMON/CF/CF_D,CF_N

      INTEGER HELC(NEXTERNAL,NCOMB)
      COMMON/HELCONFIGS/HELC

      LOGICAL MP_DONE_ONCE
      COMMON/MP_DONE_ONCE/MP_DONE_ONCE

C     ----------
C     BEGIN CODE
C     ----------

C     To be on the safe side, we always update the MP params here.
C     It can be redundant as this routine can be called a couple of
C      times for the same PS point during the stability checks.
C     But it is really not time consuming and I would rather be safe.
      CALL MP_UPDATE_AS_PARAM()

      MP_DONE_ONCE = .TRUE.

C     AS A SAFETY MEASURE WE FIRST COPY HERE THE PS POINT
      DO I=1,NEXTERNAL
        DO J=0,3
          P(J,I)=PS(J,I)
        ENDDO
      ENDDO

      DO I=0,3
        PL(I,0)=(ZERO,ZERO)
      ENDDO
      DO I=1,MAXLWFSIZE
        DO J=0,LOOPMAXCOEFS-1
          DO K=1,MAXLWFSIZE
            IF(I.EQ.K.AND.J.EQ.0) THEN
              WL(I,J,K,0)=(1.0E0_16,ZERO)
            ELSE
              WL(I,J,K,0)=(ZERO,ZERO)
            ENDIF
          ENDDO
        ENDDO
      ENDDO

      DO K=1, 3
        DO I=1,NCTAMPS
          AMPL(K,I)=(ZERO,ZERO)
        ENDDO
      ENDDO

      DO I=1,NLOOPS
        DO J=0,LOOPMAXCOEFS-1
          LOOPCOEFS(J,I)=(ZERO,ZERO)
        ENDDO
      ENDDO

      DO K=1,3
        ANSDP(K)=0.0D0
        ANS(K)=ZERO
      ENDDO

      DO H=1,NCOMB
        IF ((HELPICKED.EQ.H).OR.((HELPICKED.EQ.-1).AND.(CHECKPHASE.OR.(
     $   .NOT.HELDOUBLECHECKED).OR.(GOODHEL(H).GT.-HELOFFSET.AND.GOODHE
     $   L(H).NE.0)))) THEN
          DO I=1,NEXTERNAL
            NHEL(I)=HELC(I,H)
          ENDDO
          CALL MP_IXXXXX(P(0,1),ZERO,NHEL(1),+1*IC(1),W(1,1))
          CALL MP_OXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
          CALL MP_OXXXXX(P(0,3),MDL_MT,NHEL(3),+1*IC(3),W(1,3))
          CALL MP_IXXXXX(P(0,4),MDL_MT,NHEL(4),-1*IC(4),W(1,4))
          CALL MP_FFV1P0_3(W(1,1),W(1,2),GC_5,ZERO,ZERO,W(1,5))
C         Amplitude(s) for born diagram with ID 1
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),GC_5,AMP(1))
          CALL MP_FFV1P0_3(W(1,4),W(1,3),GC_5,ZERO,ZERO,W(1,6))
C         Counter-term amplitude(s) for loop diagram number 2
          CALL MP_R2_GG_1_0(W(1,5),W(1,6),R2_GGQ,AMPL(1,1))
C         Counter-term amplitude(s) for loop diagram number 5
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,2))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,3))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,4))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,5))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQB,AMPL(1,6))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,7))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQT,AMPL(1,8))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQQ_1EPS,AMPL(2,9))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),UV_GQQG_1EPS,AMPL(2,10))
          CALL MP_FFV1_0(W(1,1),W(1,2),W(1,6),R2_GQQ,AMPL(1,11))
C         Counter-term amplitude(s) for loop diagram number 7
          CALL MP_R2_GG_1_0(W(1,5),W(1,6),R2_GGQ,AMPL(1,12))
C         Counter-term amplitude(s) for loop diagram number 8
          CALL MP_R2_GG_1_0(W(1,5),W(1,6),R2_GGQ,AMPL(1,13))
C         Counter-term amplitude(s) for loop diagram number 9
          CALL MP_R2_GG_1_0(W(1,5),W(1,6),R2_GGQ,AMPL(1,14))
C         Counter-term amplitude(s) for loop diagram number 10
          CALL MP_R2_GG_1_R2_GG_3_0(W(1,5),W(1,6),R2_GGQ,R2_GGB,AMPL(1
     $     ,15))
C         Counter-term amplitude(s) for loop diagram number 11
          CALL MP_R2_GG_1_R2_GG_3_0(W(1,5),W(1,6),R2_GGQ,R2_GGT,AMPL(1
     $     ,16))
C         Counter-term amplitude(s) for loop diagram number 12
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,17))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,18))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,19))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,20))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQB,AMPL(1,21))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,22))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQT,AMPL(1,23))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQQ_1EPS,AMPL(2,24))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),UV_GQQG_1EPS,AMPL(2,25))
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),R2_GQQ,AMPL(1,26))
C         Counter-term amplitude(s) for loop diagram number 14
          CALL MP_R2_GG_1_R2_GG_2_0(W(1,5),W(1,6),R2_GGG_1,R2_GGG_2
     $     ,AMPL(1,27))
C         Amplitude(s) for UVCT diagram with ID 16
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),GC_5,AMPL(1,28))
          AMPL(1,28)=AMPL(1,28)*(2.0D0*UVWFCT_T_0)
C         Amplitude(s) for UVCT diagram with ID 17
          CALL MP_FFV1_0(W(1,4),W(1,3),W(1,5),GC_5,AMPL(2,29))
          AMPL(2,29)=AMPL(2,29)*(2.0D0*UVWFCT_B_0_1EPS)
          IF (.NOT.CHECKPHASE.AND.HELDOUBLECHECKED.AND.HELPICKED.EQ.
     $     -1) THEN
            DUMMY=GOODHEL(H)
          ELSE
            DUMMY=1
          ENDIF
          DO I=1,NCTAMPS
            DO J=1,NBORNAMPS
              CFTOT=CMPLX(CF_N(I,J)/REAL(ABS(CF_D(I,J)),KIND=16)
     $         ,0.0E0_16,KIND=16)
              IF(CF_D(I,J).LT.0) CFTOT=CFTOT*IMAG1
              DO K=1,3
                ANS(K)=ANS(K)+DUMMY*2.0E0_16*REAL(CFTOT*AMPL(K,I)
     $           *CONJG(AMP(J)),KIND=16)
              ENDDO
            ENDDO
          ENDDO
C         Coefficient construction for loop diagram with ID 2
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,ZERO,ZERO,PL(0,1),COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,1))
          CALL MP_FFV1L2_1(PL(0,1),W(1,6),GC_5,ZERO,ZERO,PL(0,2),COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,1),4,COEFS,4,4,WL(1,0,1,2))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,2),2,4,LOOPCOEFS(0,1),1
     $     ,30,H)
C         Coefficient construction for loop diagram with ID 3
          CALL MP_FFV1L3_2(PL(0,0),W(1,1),GC_5,ZERO,ZERO,PL(0,3),COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,3))
          CALL MP_FFV1L1P0_3(PL(0,3),W(1,2),GC_5,ZERO,ZERO,PL(0,4)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_0(WL(1,0,1,3),4,COEFS,4,4,WL(1,0,1,4))
          CALL MP_FFV1L3_2(PL(0,4),W(1,4),GC_5,MDL_MT,MDL_WT,PL(0,5)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,4),4,COEFS,4,4,WL(1,0,1,5))
          CALL MP_FFV1L1P0_3(PL(0,5),W(1,3),GC_5,ZERO,ZERO,PL(0,6)
     $     ,COEFS)
          CALL MP_UPDATE_WL_2_0(WL(1,0,1,5),4,COEFS,4,4,WL(1,0,1,6))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,6),2,4,LOOPCOEFS(0,2),1
     $     ,31,H)
C         Coefficient construction for loop diagram with ID 4
          CALL MP_FFV1L3_1(PL(0,4),W(1,3),GC_5,MDL_MT,MDL_WT,PL(0,7)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,4),4,COEFS,4,4,WL(1,0,1,7))
          CALL MP_FFV1L2P0_3(PL(0,7),W(1,4),GC_5,ZERO,ZERO,PL(0,8)
     $     ,COEFS)
          CALL MP_UPDATE_WL_2_0(WL(1,0,1,7),4,COEFS,4,4,WL(1,0,1,8))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,8),2,4,LOOPCOEFS(0,3),1
     $     ,32,H)
C         Coefficient construction for loop diagram with ID 5
          CALL MP_VVV1L2P0_1(PL(0,4),W(1,6),GC_4,ZERO,ZERO,PL(0,9)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,4),4,COEFS,4,4,WL(1,0,1,9))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,9),2,4,LOOPCOEFS(0,4),1
     $     ,33,H)
C         Coefficient construction for loop diagram with ID 6
          CALL MP_FFV1L2P0_3(PL(0,0),W(1,1),GC_5,ZERO,ZERO,PL(0,10)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_0(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,10))
          CALL MP_FFV1L3_1(PL(0,10),W(1,2),GC_5,ZERO,ZERO,PL(0,11)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,10),4,COEFS,4,4,WL(1,0,1,11))
          CALL MP_FFV1L2_1(PL(0,11),W(1,6),GC_5,ZERO,ZERO,PL(0,12)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,11),4,COEFS,4,4,WL(1,0,1,12))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,12),2,4,LOOPCOEFS(0,5),1
     $     ,34,H)
C         Coefficient construction for loop diagram with ID 7
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,ZERO,ZERO,PL(0,13)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,13))
          CALL MP_FFV1L2_1(PL(0,13),W(1,6),GC_5,ZERO,ZERO,PL(0,14)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,13),4,COEFS,4,4,WL(1,0,1,14))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,14),2,4,LOOPCOEFS(0,6),1
     $     ,35,H)
C         Coefficient construction for loop diagram with ID 8
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,ZERO,ZERO,PL(0,15)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,15))
          CALL MP_FFV1L2_1(PL(0,15),W(1,6),GC_5,ZERO,ZERO,PL(0,16)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,15),4,COEFS,4,4,WL(1,0,1,16))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,16),2,4,LOOPCOEFS(0,7),1
     $     ,36,H)
C         Coefficient construction for loop diagram with ID 9
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,ZERO,ZERO,PL(0,17)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,17))
          CALL MP_FFV1L2_1(PL(0,17),W(1,6),GC_5,ZERO,ZERO,PL(0,18)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,17),4,COEFS,4,4,WL(1,0,1,18))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,18),2,4,LOOPCOEFS(0,8),1
     $     ,37,H)
C         Coefficient construction for loop diagram with ID 10
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,MDL_MB,ZERO,PL(0,19)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,19))
          CALL MP_FFV1L2_1(PL(0,19),W(1,6),GC_5,MDL_MB,ZERO,PL(0,20)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,19),4,COEFS,4,4,WL(1,0,1,20))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,20),2,4,LOOPCOEFS(0,9),1
     $     ,38,H)
C         Coefficient construction for loop diagram with ID 11
          CALL MP_FFV1L2_1(PL(0,0),W(1,5),GC_5,MDL_MT,MDL_WT,PL(0,21)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,21))
          CALL MP_FFV1L2_1(PL(0,21),W(1,6),GC_5,MDL_MT,MDL_WT,PL(0,22)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,21),4,COEFS,4,4,WL(1,0,1,22))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,22),2,4,LOOPCOEFS(0,10),1
     $     ,39,H)
C         Coefficient construction for loop diagram with ID 12
          CALL MP_FFV1L1P0_3(PL(0,0),W(1,3),GC_5,ZERO,ZERO,PL(0,23)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_0(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,23))
          CALL MP_FFV1L3_2(PL(0,23),W(1,4),GC_5,MDL_MT,MDL_WT,PL(0,24)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,23),4,COEFS,4,4,WL(1,0,1,24))
          CALL MP_FFV1L1_2(PL(0,24),W(1,5),GC_5,MDL_MT,MDL_WT,PL(0,25)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,24),4,COEFS,4,4,WL(1,0,1,25))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,25),2,4,LOOPCOEFS(0,11),1
     $     ,40,H)
C         Coefficient construction for loop diagram with ID 13
          CALL MP_FFV1L3_1(PL(0,0),W(1,3),GC_5,MDL_MT,MDL_WT,PL(0,26)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,26))
          CALL MP_FFV1L2P0_3(PL(0,26),W(1,4),GC_5,ZERO,ZERO,PL(0,27)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_0(WL(1,0,1,26),4,COEFS,4,4,WL(1,0,1,27))
          CALL MP_VVV1L2P0_1(PL(0,27),W(1,5),GC_4,ZERO,ZERO,PL(0,28)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,27),4,COEFS,4,4,WL(1,0,1,28))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,28),2,4,LOOPCOEFS(0,12),1
     $     ,41,H)
C         Coefficient construction for loop diagram with ID 14
          CALL MP_VVV1L2P0_1(PL(0,0),W(1,5),GC_4,ZERO,ZERO,PL(0,29)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),4,COEFS,4,4,WL(1,0,1,29))
          CALL MP_VVV1L2P0_1(PL(0,29),W(1,6),GC_4,ZERO,ZERO,PL(0,30)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,29),4,COEFS,4,4,WL(1,0,1,30))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,30),2,4,LOOPCOEFS(0,13),2
     $     ,42,H)
C         Coefficient construction for loop diagram with ID 15
          CALL MP_GHGHGL2_1(PL(0,0),W(1,5),GC_4,ZERO,ZERO,PL(0,31)
     $     ,COEFS)
          CALL MP_UPDATE_WL_0_1(WL(1,0,1,0),1,COEFS,1,1,WL(1,0,1,31))
          CALL MP_GHGHGL2_1(PL(0,31),W(1,6),GC_4,ZERO,ZERO,PL(0,32)
     $     ,COEFS)
          CALL MP_UPDATE_WL_1_1(WL(1,0,1,31),1,COEFS,1,1,WL(1,0,1,32))
          CALL MP_CREATE_LOOP_COEFS(WL(1,0,1,32),2,1,LOOPCOEFS(0,14),1
     $     ,43,H)
        ENDIF
      ENDDO

C     Copy the qp wfs to the dp ones as they are used to setup the CT
C      calls.
      DO I=1,NWAVEFUNCS
        DO J=1,MAXLWFSIZE+4
          DPW(J,I)=W(J,I)
        ENDDO
      ENDDO

      DO I=1,3
        ANSDP(I)=ANS(I)
      ENDDO

      CALL MP_ADD_COEFS(LOOPCOEFS(0,1),2,LOOPCOEFS(0,6),2)
      CALL MP_ADD_COEFS(LOOPCOEFS(0,1),2,LOOPCOEFS(0,7),2)
      CALL MP_ADD_COEFS(LOOPCOEFS(0,1),2,LOOPCOEFS(0,8),2)
      CALL MP_ADD_COEFS(LOOPCOEFS(0,1),2,LOOPCOEFS(0,13),2)
      CALL MP_ADD_COEFS(LOOPCOEFS(0,1),2,LOOPCOEFS(0,14),2)
      CALL MP_ADD_COEFS(LOOPCOEFS(0,4),2,LOOPCOEFS(0,5),2)

      END

