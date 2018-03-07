      SUBROUTINE HABER(TANB,SA,CA)

C  PROGRAM HMSUSY
C      WRITTEN BY HOWARD E. HABER
C      LATEST REVISION: AUGUST 28, 1995
C      COMMENTS OR QUESTIONS: SEND E-MAIL TO HABER@SCIPP.UCSC.EDU
C      BASED ON WORK IN COLLABORATION WITH R. HEMPFLING AND A. HOANG
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/ANG/ SINA,COSA,SIN2A,COS2A,SINBPA,COSBPA,SINBMA,COSBMA
      COMMON/HINT3/HLAA,HHAA,HLHLHL,HHHLHL,HHHHHL,HHHHHH,
     1      HHHPHM,HLHPHM
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      COMMON/QMASS/ TMPOLE
      DIMENSION H(4)

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      COMMON/HMASS_HDEC/AMSM,AMA,AML,AMH,AMCH,AMAR
      COMMON/BREAK_HDEC/AMEL,AMER,AMSQ,AMUR,AMDR,AL,AU,AD,AMU,AM2
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C
C   IRC=0 TREE LEVEL ONLY
C   IRC=-1 RADIATIVE CORRECTIONS INCLUDED WITHOUT RGE IMPROVEMENT
C   IRC=1 RADIATIVE CORRECTIONS INCLUDED WITH RGE IMPROVEMENT
C   IRC=2 SLIGHT IMPROVEMENT OF TREATMENT OF STOP-SBOTTOM SECTOR
C              WITH (IRC=-2: WITHOUT) RGE IMPROVEMENT
C   IRC=3 ELLIS, RIDOLFI, AND ZWIRNER LEADING MT**4 AND MB**4
C              CORRECTIONS WITH (IRC=-3: WITHOUT) RGE IMPROVEMENT
C
C     DO 838 IRC= -1,1,2
C
C   INPUT THE MASS OF THE CP-ODD SCALAR
C
C     DO 838 IH=2,2
C     IF (IH .EQ. 1) AM=   50.D0
C     IF (IH .EQ. 2) AM= 1000.D0
C
C   INPUT THE IMPORTANT PARAMETER TANB
C
C     DO 838 ITB= 1,1
C     IF (ITB .EQ. 1) TANB= 1.5D0
C     IF (ITB .EQ. 2) TANB= 20.D0
C     TANB= 10.D0*DFLOAT(ITB)
C
C   INPUT THE SQUARK MIXING A-PARAMETERS (B AND T SECTORS ONLY)
C   IN UNITS OF THE SUPERSYMMETRY BREAKING SCALE PARAMETER (SUSY)
C
C     DO 838 IAT=  0,0
C     AA= 0.4*DFLOAT(IAT)
C     DO 838 ISQ=0,9
C     SUSY= 200.D0+100.D0*DFLOAT(ISQ)
C     IF (ISQ .EQ. 9) SUSY= 2000.D0
C     AT= AA*SUSY
C     AB= AT
C
C   MU PARAMETER SET TO SIGNMU*SUSY
C   IN PRINCIPLE, CAN CHOOSE ANY MU, ALTHOUGH IF DABS(SIGNMU) IS
C         NOT 1, THEN CONTRIBUTIONS OF GAUGINOS AND HIGGSINOS
C         TO THE RADIATIVE CORRECTIONS MUST BE MODIFIED (SLIGHTLY)
C
C     DO  838 IMU= 1,1
C     SIGNMU= -1.D0*DFLOAT(IMU)
C
C   SQUARK MASS PARAMETERS SET IN SETUP SUBROUTINE
C   PARAMETERS DEPOSITED IN COMMON/SQPARM/
C      SQM= COMMON SQUARK/SLEPTON MASS (APART FROM B AND T SECTORS)
C      SQK= SQUARK SU(2)-DOUBLET SOFT-SUSY-BREAKING MASS
C      SQU= TOP-SQUARK SU(2)-SINGLET SOFT-SUSY-BREAKING MASS
C      SQD= BOTTOM-SQUARK SU(2)-SINGLET SOFT-SUSY-BREAKING MASS
C      SUSY= COMMON GAUGINO/HIGGSINO MASS SCALE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      IRC= 2
      AM = AMA
      SUSY = AMSQ
      AT = SUSY
      AB = SUSY
      SIGNMU = 1
      IF(AMU.LT.0.D0)SIGNMU = -1
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      CALL SETUP(IRC,TANB,TM,SIGNMU,SUSY)
C
C   INITIALLY, ALL FIVE SUSY-BREAKING MASSES SET EQUAL.
C   THIS CAN BE CHANGED EITHER RIGHT HERE OR DIRECTLY IN THE
C   SETUP SUBROUTINE.
C
C   SUBROUTINE HSUSY COMPUTES HIGGS MASSES AND COUPLINGS
C   IT COMPUTES STOP AND SBOTTOM SPECTRUM FIRST, AND DEPOSITS THE
C   RESULTS IN COMMON/SQPARM/.  OUTPUT IS:
C        STA2,STB2= TOP-SQUARK SQUARED-MASSES
C        SBA2,SBB2= BOTTOM-SQUARK SQUARED-MASSES
C   NEXT IT COMPUTES THE HIGGS MASSES AND PUTS THEM IN THE ARRAY H()
C        H(1)= HEAVY CP-EVEN MASS
C        H(2)= LIGHT CP-EVEN MASS
C        H(3)= CP-ODD MASS (INPUT AS "AM" ABOVE)
C        H(4)= CHARGED HIGGS MASS
C   MIXING ANGLE FACTORS THAT APPEAR IN HIGGS FEYNMAN RULES
C   DEPOSITED IN  COMMON/ANG/.  TANB IS INPUT, WHILE OUTPUT INCLUDES:
C        SINA= SIN(ALPHA) [ALPHA: CP-EVEN HIGGS MIXING ANGLE]
C        COSA= COS(ALPHA)
C        SIN2A= SIN(2*ALPHA)
C        COS2A= COS(2*ALPHA)
C        SINBPA= SIN(BETA+ALPHA)
C        COSBPA= COS(BETA+ALPHA)
C        SINBMA= SIN(BETA-ALPHA)
C        COSBMA= COS(BETA-ALPHA)
C   THREE-HIGGS COUPLING DEPOSITED IN COMMON/HINT3/.  NOTATION:
C        HL= LIGHT CP-EVEN HIGGS
C        HH= HEAVY CP-EVEN HIGGS
C         A= CP-ODD HIGGS
C        HPHM= CHARGED HIGGS PAIR
C   FOR EXAMPLE, HLHPHM IS THE FEYNMAN RULE FOR THE INTERACTION OF
C   THE LIGHT CP-EVEN HIGGS WITH A CHARGED HIGGS PAIR (WITHOUT A
C   FACTOR OF I), HLHLHL IS THE THREE LIGHT CP-HIGGS COUPLING, ETC.
C
C   IERR=0 IF THE PROGRAM SUCCEEDS.  IF ONE FINDS A NEGATIVE
C   SQUARED MASS FOR ANY SCALAR (USUALLY, SCALAR-TOP, SCALAR-BOTTOM,
C   THE LIGHT CP-EVEN HIGGS OR THE CHARGED HIGGS), THE PROGRAM
C   RETURNS IERR>0.
C
      CALL HMSUSY(IRC,AM,TM,TANB,SUSY,AT,AB,H,ALF,IERR)
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      AML = H(2)
      AMH = H(1)
C     AMA = H(3)
      AMCH = H(4)
      AMAR = H(3)
      SA = SINA
      CA = COSA
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C   SLIGHT INACCURACIES OF THE PROGRAM:
C      1. IRC=2 SLIGHTLY IMPROVES NEUTRAL SCALAR MASSES, BUT
C            NO IMPROVEMENT YET FOR CHARGED SCALAR MASSES.
C      2. LEADING LOGS FOR CHARGED SCALAR MASS CORRECT ONLY
C            IF M(A)=O(ZMASS).
C      3. LEADING LOGS FOR HEAVY CP-EVEN SCALAR MASS CORRECT ONLY
C            IF M(A)=O(ZMASS).
C   IN CASES 2 AND 3, THE RELATIVE ERROR MADE IS RATHER MINOR,
C   SINCE HEAVY SCALARS ARE ROUGHLY DEGENERATE WITH THE CP-ODD SCALAR.
C      4. NO DETAILED STUDY YET OF ACCURACY OF RGE-IMPROVEMENT VIA
C            THE USE OF MT(Q) FOR WIDELY SPLIT SQK, SQU, AND SQD
C
      IF (STB2 .LT. 0.D0) GO TO 838
      IF (SBB2 .LT. 0.D0) GO TO 838
      STOP1= DSQRT(STA2)
      STOP2= DSQRT(STB2)
      SBOT1= DSQRT(SBA2)
      SBOT2= DSQRT(SBB2)
      IF (IERR .GT. 0) GO TO 838
C 500 WRITE(6,565) H(2),H(1),H(3),H(4),TANB,AA,SUSY,XMU
C 500 WRITE(6,565) H(2),H(3),TANB,AA,SUSY,XMU,H(4),STOPB
C 500 WRITE(6,564) IRC,H(2),H(3),TANB,TM,AT,SUSY,XMU
C 500 WRITE(6,565) XMU,H(3),H(2) ,H(4),TANB,AT,AB,SUSY
C     WRITE(6,565) SQK,SQU,SQD,XMU,STOP1,STOP2,SBOT1,SBOT2
  564 FORMAT(I2,7(F9.3,1X))
  565 FORMAT(8(F9.3,1X))
  838 CONTINUE
C     STOP
      RETURN
      END

      SUBROUTINE SETUP(IRC,TANB,TMASS,SIGNMU,SUSY)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      COMMON/QMASS/ TMPOLE
      DATA PI/3.1415926535D0/
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      COMMON/PARAM_HDEC/GF0,ALPH0,AMTAU0,AMMUON0,AMZ0,AMW0
      COMMON/MASSES_HDEC/AMS0,AMC0,AMB0,AMT0
      COMMON/BREAK_HDEC/AMEL,AMER,AMSQ,AMUR,AMDR,AL,AU,AD,AMU,AM2
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      TMPOLE= AMT0
      BMASS= AMB0
      ALS=ALPHAS_HDEC(TMPOLE,3)
      SINW2 = 1-AMW0**2/AMZ0**2
      ALPHA = DSQRT(2.D0)*GF0/PI*AMW0**2*SINW2
      ZMASS= AMZ0
      WMASS= AMW0
      SQM= AMEL
      SQK= AMSQ
      SQU= AMUR
      SQD= AMDR
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C     TMPOLE= 175.D0
C     ALS=ALFS(TMPOLE)
      ASCORR= 1.D0+4.D0*ALS/(3.D0*PI)
      TMASS= TMPOLE/ASCORR
C     TMASST= TMPOLE/ASCORR
C     TMASS= TMPOLE
C     IF (IRC .GT. 0.D0) TMASS= TMASST
C     BMASS= 4.7D0
C     ALPHA= 1.D0/128.D0
C     SINW2= 0.23D0
      COSW2= 1.D0-SINW2
      COSW= DSQRT(COSW2)
C     ZMASS= 91.1888D0
C     WMASS= ZMASS*COSW
      W2= WMASS**2
      E2= 4.D0*PI*ALPHA
      G2= E2/SINW2
      GP2= E2/COSW2
      SINB= TANB/DSQRT(1.D0+TANB**2)
      COSB= 1.D0/DSQRT(1.D0+TANB**2)
      COTB= 1.D0/TANB
C     SQM= SUSY
C     SQK= SUSY
C     SQU= SUSY
C     SQD= SUSY
      XMU= SIGNMU*SUSY
      RETURN
      END
C
C   IF CHARGED HIGGS MASS SQUARED IS NEGATIVE, PROGRAM RETURNS ZERO
C
      SUBROUTINE HMSUSY(IRC,AMASS,TMASS,TANB,SUSY,AT,AB,H,ALF,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/ANG/ SINA,COSA,SIN2A,COS2A,SINBPA,COSBPA,SINBMA,COSBMA
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      COMMON/HINT3/HLAA,HHAA,HLHLHL,HHHLHL,HHHHHL,HHHHHH,
     1      HHHPHM,HLHPHM
      COMMON/QMASS/ TMPOLE
      COMMON/TEST/ D11,D12,D22,DP
      DIMENSION H(4),DL(7)
      DATA PI/3.1415926535D0/, ZERO/0.D0/
      IERR= 0
      STEP= 0.D0
      IF (AMASS .GE. ZMASS) STEP= 1.D0
      Z2= ZMASS**2
      W2= WMASS**2
      A2= AMASS**2
      B2= BMASS**2
      COSW2= 1.D0-SINW2
      COS2W= COSW2-SINW2
      SINW= DSQRT(SINW2)
      COSW= DSQRT(COSW2)
      EU= 2.D0/3.D0
      ED= -1.D0/3.D0
      SINB2= SINB**2
      COSB2= COSB**2
      COS2B= COSB**2-SINB**2
      COS2B2= COS2B**2
      SIN2B= 2.D0*SINB*COSB
      TANB2= TANB**2
      COTB2= COTB**2
      S11= A2*SINB2+Z2*COSB2
      S22= A2*COSB2+Z2*SINB2
      S12= -(A2+Z2)*SINB*COSB
      SPM= A2+W2
      IF (IRC .NE. 0) GO TO 25
      CALL CPEVEN(S11,S22,S12,H1R,H2R,SIN2A,COS2A)
      DPM= SPM
      GO TO 50
C
C   HERE WE ALLOW FOR
C   MIXING OF Q(L) AND Q(R) ONLY FOR THE S-TOP AND S-BOTTOM
C   OTHERWISE, THERE IS NO MIXING.
C
   25 SUSY2= SUSY**2
      SQM2= SQM*SQM
      SQBL2= SQK**2+BMASS**2-Z2*COS2B*(0.5D0+ED*SINW2)
      SQBR2= SQD**2+BMASS**2+Z2*COS2B*ED*SINW2
      SQTL2= SQK**2+TMPOLE**2+Z2*COS2B*(0.5D0-EU*SINW2)
      SQTR2= SQU**2+TMPOLE**2+Z2*COS2B*EU*SINW2
      XB= AB-XMU*TANB
      XT= AT-XMU*COTB
      AB3= -XB*BMASS/(2.D0*WMASS)
      AT3= -XT*TMPOLE/(2.D0*WMASS)
      DIFFT= SQTL2-SQTR2
      DIFFB= SQBL2-SQBR2
      TMIX= -4.D0*AT3*WMASS
      BMIX= -4.D0*AB3*WMASS
      STA2= 0.5D0*(SQTL2+SQTR2+DSQRT(DIFFT**2+TMIX**2))
      STB2= 0.5D0*(SQTL2+SQTR2-DSQRT(DIFFT**2+TMIX**2))
      SBA2= 0.5D0*(SQBL2+SQBR2+DSQRT(DIFFB**2+BMIX**2))
      SBB2= 0.5D0*(SQBL2+SQBR2-DSQRT(DIFFB**2+BMIX**2))
      IF (SBB2 .LT. ZERO) GO TO 291
      IF (STB2 .LT. ZERO) GO TO 292
      SQT1= DSQRT(STA2)
      SQT2= DSQRT(STB2)
      SQB1= DSQRT(SBA2)
      SQB2= DSQRT(SBB2)
      SQTM2= SQT1*SQT2
      SQBM2= SQB1*SQB2
      SQTBM2= DSQRT(SQTM2*SQBM2)
      SMT2= 0.5D0*(SQK**2+SQU**2)
      SMT= DSQRT(SMT2)
      QP= DSQRT(SMT*TMPOLE)
      TMASS1= TMASSR(QP,TMASS)
      IF (IRC .LE. 0) TMASS1= TMASS
      T2= TMASS1**2
      TMASS2= TMASSR(SMT,TMASS)
      IF (IRC .LE. 0) TMASS2= TMASS
      COLOR= 3.D0
      GENS= 3.D0
      PT= COLOR*(1.D0-4.D0*EU*SINW2+8.D0*EU**2*SINW2**2)
      PB= COLOR*(1.D0+4.D0*ED*SINW2+8.D0*ED**2*SINW2**2)
      PF= (GENS-1.D0)*(PT+PB)+2.D0*GENS*(1.D0-2.D0*SINW2+4.D0*SINW2**2)
      P22= -2.D0*(32.D0*SINW2**2-54.D0*SINW2+27.D0)
      P12= -2.D0*(8.D0*SINW2**2-6.D0*SINW2-9.D0)
      P2H= -10.D0+2.D0*SINW2-2*SINW2**2
      P2HP= 8.D0-22.D0*SINW2+10.D0*SINW2**2
      P1H= -9.D0*COS2B2**2+(1.D0-2.D0*SINW2+2.D0*SINW2**2)*COS2B2
      PH12= (P1H-P2H)*STEP
      PH12P= (P1H+P2HP)*STEP
      FACT= COLOR*G2/(16.D0*PI**2*W2)
      FACT1= COLOR*G2*T2/(32.D0*PI**2*COSW2*SINB2)
      FACT2= COLOR*G2*B2/(32.D0*PI**2*COSW2*COSB2)
      FACTT= G2*Z2*SINB2/(96.D0*PI**2*COSW2)
      FACBB= G2*Z2*COSB2/(96.D0*PI**2*COSW2)
      FACTBT= G2*Z2/(96.D0*PI**2*COSW2)
      DLOGW= DLOG(SUSY2/W2)
      DLOGZ= DLOG(SUSY2/Z2)
      DLOGF= DLOG(SQM2/Z2)
      DLOGFW= DLOG(SQM2/W2)
C     DLOGT= DLOG(SUSY2/T2)
C     DLOGTB= DLOG(SUSY2/T2)
C     DLOGB= DLOG(SUSY2/Z2)
      DLOGT= DLOG(SQTM2/T2)
      DLOGTB= DLOG(SQTBM2/T2)
      DLOGB= DLOG(SQBM2/Z2)
      DLOGA= DLOG(A2/Z2)
      IF (IABS(IRC) .NE. 3) GO TO 30
      XB2= XB**2
      XT2= XT**2
      AB2= AB**2
      AT2= AT**2
      XMU2= XMU**2
      DLBF= FH(SBA2,SBB2)
      DLTF= FH(STA2,STB2)
      DLBG= FG(SBA2,SBB2)
      DLTG= FG(STA2,STB2)
      T4= TMASS2**4/SINB2
      B4= BMASS**4/COSB2
      DH11= FACT*(B4*(AB2*XB2*DLBG+2.D0*AB*XB*DLBF)+T4*XMU2*XT2*DLTG)
      DH22= FACT*(T4*(AT2*XT2*DLTG+2.D0*AT*XT*DLTF)+B4*XMU2*XB2*DLBG)
      DH12= -XMU*FACT*(B4*XB*(DLBF+AB*XB*DLBG)+T4*XT*(DLTF+AT*XT*DLTG))
      DM11= S11+DH11+2.D0*FACT*B4*DLOGB
      DM22= S22+DH22+2.D0*FACT*T2**2*DLOGT/SINB2
      DM12= S12+DH12
      GO TO 40
   30 DNL22= 0.D0
C
C   DNL22: MT**2 NON-LEADING LOG PIECE
C
      DNL22= FACT*T2*Z2/(3.D0*SINB2)
      CALL DELUD(IRC,TANB,TMASS1,AT,AB,DUD11,DUD22,DUD12,DUDPM)
      CALL DELHM(IRC,TANB,TMASS2,AT,AB,DHZ11,DHZ22,DHZ12,DHZPM)
      DM11= S11+DHZ11+DUD11
     1        +(FACT*(2.D0*B2**2/COSB2-Z2*B2)+FACBB*PB)*DLOGB
     2        +FACBB*(PT*DLOGT+PF*DLOGF+P22*DLOGZ+PH12*DLOGA)
      DM22= S22+DHZ22+DUD22+DNL22
     1        +(FACT*(2.D0*T2**2/SINB2-Z2*T2)+FACTT*PT)*DLOGT
     2        +FACTT*(PB*DLOGB+PF*DLOGF+P22*DLOGZ+PH12*DLOGA)
      DM12= S12+DHZ12+DUD12
     1        +SINB*COSB*((FACT1-FACTBT*PT)*DLOGT
     2        +(FACT2-FACTBT*PB)*DLOGB-FACTBT*(PF*DLOGF+P12*DLOGZ)
     3        +FACTBT*PH12P*DLOGA)
   40 CALL CPEVEN(DM11,DM22,DM12,H1R,H2R,SIN2A,COS2A)
      FACTG= COLOR*G2/(32.D0*PI**2)
      FACTG2= G2/(48.D0*PI**2)
      FACTGP= 5.D0*GP2*W2/(16.D0*PI**2)
      XCG= COLOR*(GENS-1.D0)+GENS
      DPML= SPM+FACTG*(2.D0*T2*B2/(W2*SINB2*COSB2)-T2/SINB2-B2/COSB2
     1         +2.D0*W2/3.D0)*DLOGTB + FACTGP*DLOGW
     2         +FACTG2*(XCG*DLOGFW-9.D0*DLOGW)
C     CORRQ=-0.5D0*T2*(W2+A2*COSB2-4.D0*B2/COSB2)/(W2*SINB2)
C    1     -(W2*(3.D0-5.D0*SINB2)/9.D0+2.D0*A2*COSB2/3.D0
C    2     -0.5D0*B2*(4.D0-5.D0*SINB2)/COSB2)/SINB2
C    3     -0.5D0*A2*(A2*COSB2/3.D0
C    4         -B2*(4.D0*COSB2+3.D0*SINB2**2)/(2.D0*COSB2))/(W2*SINB2)
C    5     +B2*(A2*SINB2*DLOG(T2/A2)-2.D0*B2*DLOG(T2/B2)/SINB2)
C    6         /(W2*COSB2)
C     CORRSQ=T2**3/(2.D0*W2*SINB2*SMT2)
C    1    +T2**2*(W2*(8.D0-5.D0*SINB2)-Z2*COS2B+A2*COSB2
C    2    -3.D0*B2*(2.D0+SINB2)/COSB2)/(6.D0*W2*SINB2*SMT2)
C     DPMNL= FACTG*(CORRQ+CORRSQ)
C     DPM= DPML+DPMNL+DHZPM
      DPM= DPML+DHZPM
   50 SIGN= 1.D0
      IF (SIN2A .LT. 0.D0) SIGN= -1.D0
C     COSA= DSQRT((1.D0+COS2A)/2.D0)
C     SINA= SIGN*DSQRT((1.D0-COS2A)/2.D0)
C     ALF= SIGN*DACOS(COSA)
      ALF= 0.5D0*ATAN2(SIN2A,COS2A)
      COSA= COS(ALF)
      SINA= SIN(ALF)
      BET= DATAN(TANB)
      SINBPA= DSIN(BET+ALF)
      SINBMA= DSIN(BET-ALF)
      COSBPA= DCOS(BET+ALF)
      COSBMA= DCOS(BET-ALF)
      H(1)= DSQRT(H1R)
      IF (H2R .LT. ZERO) GO TO 293
      H(2)= DSQRT(H2R)
      H(3)= AMASS
      H(4)= 0.D0
      IF (DPM .LT. ZERO) GO TO 294
      H(4)= DSQRT(DPM)
      CALL HLAMBG(IRC,TANB,AMASS,TMASS1,TMASS2,SUSY,AT,AB,DL)
      CALL HIGGS3(IRC,H,DL)
      RETURN
  291 IERR=1
      WRITE(6,991)
      RETURN
  292 IERR=2
      WRITE(6,992)
      RETURN
  293 IERR= 3
      WRITE(6,993)
      RETURN
  294 IERR= 4
      WRITE(6,994)
  991 FORMAT(1X,'ERROR: S-BOTTOM MASS SQUARED EIGENVALUE IS NEGATIVE')
  992 FORMAT(1X,'ERROR: S-TOP MASS SQUARED EIGENVALUE IS NEGATIVE')
  993 FORMAT(1X,'ERROR: LIGHT CP-EVEN SCALAR SQUARED-MASS IS NEGATIVE')
  994 FORMAT(1X,'ERROR: CHARGED HIGGS SQUARED MASS IS NEGATIVE')
      RETURN
      END

      SUBROUTINE CPEVEN(S11,S22,S12,H1,H2,SIN2A,COS2A)
      IMPLICIT REAL*8(A-H,O-Z)
      DISCR= DSQRT((S11-S22)**2+4.D0*S12**2)
      H1= 0.5D0*(S11+S22+DISCR)
      H2= 0.5D0*(S11+S22-DISCR)
      SIN2A= 2.D0*S12/DISCR
      COS2A= (S11-S22)/DISCR
      RETURN
      END

      SUBROUTINE DELHM(IRC,TANB,TMASS,AT,AB,DHZ11,DHZ22,DHZ12,DHZPM)
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      DATA PI/3.1415926535D0/
      W2= WMASS*WMASS
      Z2= ZMASS*ZMASS
      AT2= AT*AT
      AB2= AB*AB
      XMU2= XMU*XMU
      GSQ= G2+GP2
      EU= 2.D0/3.D0
      ED= -1.D0/3.D0
      COLOR= 3.D0
      CB2= COSB**2
      SB2= SINB**2
      T2= TMASS**2
      B2= BMASS**2
      T4= TMASS**4/SB2
      B4= BMASS**4/CB2
      T2D= TMASS**2/SB2
      B2D= BMASS**2/CB2
      XB= AB-XMU*TANB
      XT= AT-XMU*COTB
      YB= AB+XMU*COTB
      YT= AT+XMU*TANB
      XB2= XB**2
      XT2= XT**2
      Q2= SQK**2
      U2= SQU**2
      D2= SQD**2
      UF= FF_HABER(U2,Q2)
      DF= FF_HABER(D2,Q2)
      UG= FG(Q2,U2)
      DG= FG(Q2,D2)
      UKP= UF+2.D0*EU*SINW2*(Q2-U2)*UG
      DKP= DF-2.D0*ED*SINW2*(Q2-D2)*DG
      UH= FH(Q2,U2)
      DH= FH(Q2,D2)
      UB= BP(Q2,U2)
      DB= BP(Q2,D2)
      FPBPU= UF+UB
      FPBPD= DF+DB
      FMBPU= UF-UB
      FMBPD= DF-DB
      HUD= HP(Q2,U2,D2)
      FUD= FP(Q2,U2,D2)
      FACT= COLOR*G2/(16.D0*PI**2*W2)
      DHZPM= 0.5D0*FACT*(XMU2*(T4*UF+B4*DF+2.D0*T2D*B2D*HUD)
     1       -T2D*B2D*(AB2*DF+AT2*UF+2.D0*AT*AB*HUD+FUD*(XMU2-AT*AB)**2)
     2       -W2*B2D*(XMU2*FPBPD-AB2*FMBPD)
     3       -W2*T2D*(XMU2*FPBPU-AT2*FMBPU))
      IF (IABS(IRC) .NE. 2) GO TO 10
      TQ2= STA2
      BQ2= SBA2
      U2= STB2
      D2= SBB2
      UF= FF_HABER(U2,TQ2)
      DF= FF_HABER(D2,BQ2)
      UG= FG(TQ2,U2)
      DG= FG(BQ2,D2)
      UKP= UF+2.D0*EU*SINW2*(TQ2-U2)*UG
      DKP= DF-2.D0*ED*SINW2*(BQ2-D2)*DG
      UH= FH(TQ2,U2)
      DH= FH(BQ2,D2)
      UB= BP(TQ2,U2)
      DB= BP(BQ2,D2)
   10 DHZ11= FACT*(B4*AB*XB*(2.D0*DH+AB*XB*DG)+T4*XMU2*XT2*UG
     1      +Z2*(B2*AB*(XB*DKP-AB*DB)+T2*XMU*COTB*(XT*UKP-XMU*COTB*UB)))
      DHZ22= FACT*(T4*AT*XT*(2.D0*UH+AT*XT*UG)+B4*XMU2*XB2*DG
     1      +Z2*(T2*AT*(XT*UKP-AT*UB)+B2*XMU*TANB*(XB*DKP-XMU*TANB*DB)))
      DHZ12= -FACT*(B4*XMU*XB*(DH+AB*XB*DG)+T4*XMU*XT*(UH+AT*XT*UG)
     1       -0.5D0*Z2*(T2*COTB*((XMU2+AT2)*UB-XT*YT*UKP)
     2                 +B2*TANB*((XMU2+AB2)*DB-XB*YB*DKP)))
      RETURN
      END

      SUBROUTINE DELUD(IRC,TANB,TMASS,AT,AB,DHZ11,DHZ22,DHZ12,DHZPM)
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      DATA PI/3.1415926535D0/
      SINB2= SINB**2
      COSB2= COSB**2
      W2= WMASS*WMASS
      Z2= ZMASS*ZMASS
      T2= TMASS**2
      B2= BMASS**2
      Q2= SQK**2
      U2= SQU**2
      D2= SQD**2
      EU= 2.D0/3.D0
      ED= -1.D0/3.D0
      COLOR= 3.D0
      FACT= COLOR*G2*Z2/(16.D0*PI**2*W2)
      FACTG= COLOR*G2/(64.D0*PI**2)
      DHZPM= FACTG*(T2/SINB2+B2/COSB2-2.D0*W2/3.D0)*DLOG(Q2**2/(U2*D2))
      IF (IABS(IRC) .EQ. 2) GO TO 50
      DHZ11= -FACT*(B2*(0.5D0+2.D0*ED*SINW2)*DLOG(Q2/D2))
      DHZ22= -FACT*(T2*(0.5D0-2.D0*EU*SINW2)*DLOG(Q2/U2))
      DHZ12= 0.5D0*FACT*(B2*TANB*(0.5D0+2.D0*ED*SINW2)*DLOG(Q2/D2)
     1              +T2*COTB*(0.5D0-2.D0*EU*SINW2)*DLOG(Q2/U2))
      RETURN
   50 DHZ11= -FACT*(B2*(0.5D0+2.D0*ED*SINW2)*DLOG(SBA2/SBB2))
      DHZ22= -FACT*(T2*(0.5D0-2.D0*EU*SINW2)*DLOG(STA2/STB2))
      DHZ12= 0.5D0*FACT*(B2*TANB*(0.5D0+2.D0*ED*SINW2)*DLOG(SBA2/SBB2)
     1              +T2*COTB*(0.5D0-2.D0*EU*SINW2)*DLOG(STA2/STB2))
      END

      SUBROUTINE HLAMBG(IRC,TANB,AMASS,TM1,TM2,SUSY,AT,AB,DLT)
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/SQPARM/ SQM,SQK,SQU,SQD,XMU,STA2,STB2,SBA2,SBB2
      COMMON/TEST/ D11,D12,D22,DP
      DIMENSION DL1(7),DL2(7),DL3(7),DL4(7),DLT(7)
      DATA PI/3.1415926535D0/
C
C   DLN(3)= LAMBDA(3)+LAMBDA(4),   N=1,...,4
C   DLN(4)= LAMBDA(5)-LAMBDA(4),   N=1,...,4
C
      GSQ= G2+GP2
      DLT(1)= 0.25D0*GSQ
      DLT(2)= 0.25D0*GSQ
      DLT(3)= -0.25D0*GSQ
      DLT(4)= 0.5D0*G2
      DLT(5)=0
      DLT(6)=0
      DLT(7)=0
      IF (IRC .EQ. 0) RETURN
      STEP= 0.D0
      IF (AMASS .GE. ZMASS) STEP= 1.D0
      A2= AMASS**2
      COSW2= 1.D0-SINW2
      T2= TM1**2
      B2= BMASS**2
      SUSY2= SUSY*SUSY
      SQM2= SQM*SQM
      SQTM2= DSQRT(STA2*STB2)
      SQBM2= DSQRT(SBA2*SBB2)
      W2= WMASS*WMASS
      Z2= ZMASS**2
      AT2= AT*AT
      AB2= AB*AB
      XMU2= XMU*XMU
      V2= 4.D0*W2/G2
      CB2= COSB**2
      SB2= SINB**2
      COS2B= COSB**2-SINB**2
      COS2B2= COS2B**2
      EU= 2.D0/3.D0
      ED= -1.D0/3.D0
      COLOR= 3.D0
      GENS= 3.D0
      PT= COLOR*(1.D0-4.D0*EU*SINW2+8.D0*EU**2*SINW2**2)
      PB= COLOR*(1.D0+4.D0*ED*SINW2+8.D0*ED**2*SINW2**2)
      PF= (GENS-1.D0)*(PT+PB)+2.D0*GENS*(1.D0-2.D0*SINW2+4.D0*SINW2**2)
      P22= -2.D0*(32.D0*SINW2**2-54.D0*SINW2+27.D0)
      P12= -2.D0*(8.D0*SINW2**2-6.D0*SINW2-9.D0)
      P2H= -10.D0+2.D0*SINW2-2*SINW2**2
      P2HP= 8.D0-22.D0*SINW2+10.D0*SINW2**2
      P1H= -9.D0*COS2B2**2+(1.D0-2.D0*SINW2+2.D0*SINW2**2)*COS2B2
      PH12= (P1H-P2H)*STEP
      PH12P= (P1H+P2HP)*STEP
      FACT= COLOR*G2/(16.D0*PI**2*W2*Z2)
      FACT1= COLOR*G2*T2/(32.D0*PI**2*COSW2*SB2*Z2)
      FACT2= COLOR*G2*B2/(32.D0*PI**2*COSW2*CB2*Z2)
      FACT3= G2/(96.D0*PI**2*COSW2)
      FACTC= COLOR*G2/(32.D0*PI**2)
      FACTC2= G2/(48.D0*PI**2)
      FACTPC= 5.D0*GP2/(16.D0*PI**2)
      DLOGW= DLOG(SUSY2/W2)
      DLOGZ= DLOG(SUSY2/Z2)
      DLOGF= DLOG(SQM2/Z2)
      DLOGFW= DLOG(SQM2/W2)
      DLOGT= DLOG(SQTM2/T2)
      DLOGB= DLOG(SQBM2/Z2)
      DLOGA= DLOG(A2/Z2)
      XCG= COLOR*(GENS-1.D0)+GENS
      DL1(1)= 0.25D0*GSQ*(1.D0
     1        +(FACT*(2.D0*B2**2/CB2-Z2*B2)/CB2+FACT3*PB)*DLOGB
     2        +FACT3*(PF*DLOGF+P22*DLOGZ+PT*DLOGT+PH12*DLOGA))
      DL1(2)= 0.25D0*GSQ*(1.D0
     1        +(FACT*(2.D0*T2**2/SB2-Z2*T2)/SB2+FACT3*PT)*DLOGT
     2        +FACT3*(PF*DLOGF+P22*DLOGZ+PB*DLOGB+PH12*DLOGA))
      DL1(3)= -0.25D0*GSQ*(1.D0
     1        -(FACT1-FACT3*PT)*DLOGT-(FACT2-FACT3*PB)*DLOGB
     2        +FACT3*(PF*DLOGF+P12*DLOGZ-PH12P*DLOGA))
      DL1(4)= 0.5D0*G2*(1.D0
     1        +FACTC*(2.D0*T2*B2/(W2**2*SB2*CB2)+2.D0/3.D0
     2        -(T2/SB2+B2/CB2)/W2)*DLOGT+FACTPC*DLOGW
     3        +FACTC2*(XCG*DLOGFW-9.D0*DLOGW))
      DL1(5)=0
      DL1(6)=0
      DL1(7)=0
      AFACT= COLOR/(16.D0*PI**2)
      HB2= 0.5D0*G2*B2/(W2*CB2)
      HT2= 0.5D0*G2*TM2**2/(W2*SB2)
      HB4= HB2*HB2
      HT4= HT2*HT2
      Q2= SQK**2
      U2= SQU**2
      D2= SQD**2
      UF= FF_HABER(U2,Q2)
      DF= FF_HABER(D2,Q2)
      UG= FG(Q2,U2)
      DG= FG(Q2,D2)
      UK= 0.25D0*(GSQ*UF+2.D0*EU*GP2*(Q2-U2)*UG)
      DK= 0.25D0*(GSQ*DF-2.D0*ED*GP2*(Q2-D2)*DG)
      UH= FH(Q2,U2)
      DH= FH(Q2,D2)
      UB= BP(Q2,U2)
      DB= BP(Q2,D2)
      A11= -AFACT*(HT2*XMU2*UB+HB2*AB2*DB)
      A22= -AFACT*(HT2*AT2*UB+HB2*XMU2*DB)
      DL2(1)= 0.5D0*GSQ*A11
      DL2(2)= 0.5D0*GSQ*A22
      DL2(3)= -0.25D0*GSQ*(A11+A22)
      DL2(4)= 0.5D0*G2*(A11+A22)
      DL2(5)= 0.D0
      DL2(6)= 0.D0
      DL2(7)= 0.D0
      DL3(1)= 2.D0*AFACT*(AB2*HB4*DH-HT2*XMU2*UK+HB2*AB2*DK)
      DL3(2)= 2.D0*AFACT*(AT2*HT4*UH-HB2*XMU2*DK+HT2*AT2*UK)
      DL3(3)= AFACT*(XMU2*(HB4*DH+HT4*UH)+HB2*(XMU2-AB2)*DK
     1           +HT2*(XMU2-AT2)*UK)
      DL3(4)= -0.5D0*AFACT*(4.D0*HB2*HT2*(AT*AB-XMU2)*HP(Q2,U2,D2)
     1           +HB2*DF*(2.D0*(HT2*AB2-HB2*XMU2)+G2*(XMU2-AB2))
     2           +HT2*UF*(2.D0*(HB2*AT2-HT2*XMU2)+G2*(XMU2-AT2)))
      DL3(5)= 0.D0
      DL3(6)= -AFACT*XMU*(HB4*AB*DH+HB2*AB*DK-HT2*AT*UK)
      DL3(7)= -AFACT*XMU*(HT4*AT*UH+HT2*AT*UK-HB2*AB*DK)
      DL4(1)= AFACT*(DG*(AB2*HB2)**2+UG*(XMU2*HT2)**2)
      DL4(2)= AFACT*(UG*(AT2*HT2)**2+DG*(XMU2*HB2)**2)
      DL4(3)= 2.D0*AFACT*XMU2*(AT2*HT4*UG+AB2*HB4*DG)
      DL4(4)= -AFACT*(HT2*HB2*(XMU2-AT*AB)**2*FP(Q2,U2,D2))
      DL4(5)= AFACT*XMU2*(AT2*HT4*UG+AB2*HB4*DG)
      DL4(6)= -AFACT*XMU*(AT*XMU2*HT4*UG+AB*AB2*HB4*DG)
      DL4(7)= -AFACT*XMU*(AB*XMU2*HB4*DG+AT*AT2*HT4*UG)
      DO 10 I=1,7
   10 DLT(I)= DL1(I)+DL2(I)+DL3(I)+DL4(I)
      D11= A2*SB2+V2*(DLT(1)*CB2+DLT(5)*SB2+2.D0*SINB*COSB*DLT(6))
      D22= A2*CB2+V2*(DLT(2)*SB2+DLT(5)*CB2+2.D0*SINB*COSB*DLT(7))
      D12= -A2*SINB*COSB+V2*(DLT(3)*SINB*COSB+DLT(6)*CB2+DLT(7)*SB2)
      DP= A2+0.5D0*V2*DLT(4)
      RETURN
      END
C
      FUNCTION FF_HABER(X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      FF_HABER= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      FF_HABER= 1.D0/(X2-Y2)-X2*DLOG(X2/Y2)/(X2-Y2)**2
      RETURN
   50 FF_HABER= (-1.D0/2.D0+XYD/6.D0-XYD**2/12.D0+XYD**3/20.D0)/Y2
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF FF-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION FFD(X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      FFD= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      FFD= 1.D0-X2*DLOG(X2/Y2)/(X2-Y2)
      RETURN
   50 FFD= -XYD/2.D0+XYD**2/6.D0-XYD**3/12.D0+XYD**4/20.D0
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF FFD-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION FG(X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      FG= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      FG= 2.D0/(X2-Y2)**2-(X2+Y2)*DLOG(X2/Y2)/(X2-Y2)**3
      RETURN
   50 FG= (-1.D0/6.D0+XYD/6.D0-3.D0*XYD**2/20.D0
     1           +2.D0*XYD**3/15.D0)/Y2**2
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF FG-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION FH(X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      FH= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      FH= DLOG(X2/Y2)/(X2-Y2)
      RETURN
   50 FH= (1.D0-XYD/2.D0+XYD**2/3.D0-XYD**3/4.D0+XYD**4/5.D0)/Y2
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF FH-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION BP(X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      BP= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      BP= 0.5D0*(X2+Y2-2.D0*X2*Y2*DLOG(X2/Y2)/(X2-Y2))/(X2-Y2)**2
      RETURN
   50 BP= (1.D0/6.D0-XYD/12.D0+XYD**2/20.D0-XYD**3/30.D0)/Y2
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF BP-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION FP(Z2,X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      FP= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      FP= (FF_HABER(X2,Z2)-FF_HABER(Y2,Z2))/(X2-Y2)
      RETURN
   50 FP= -FG(Y2,Z2)+XYD*FP1(Y2,Z2)+XYD**2*FP2(Y2,Z2)+XYD**3*FP3(Y2,Z2)
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF FP-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION HP(Z2,X2,Y2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      HP= 0.D0
      IF (X2 .LE. 0.D0) GO TO 100
      IF (Y2 .LE. 0.D0) GO TO 100
      XYD= (X2-Y2)/Y2
      DXYD= DABS(XYD)
      IF (DXYD .LT. SMALL) GO TO 50
      HP= (FFD(X2,Z2)-FFD(Y2,Z2))/(X2-Y2)
      RETURN
   50 HP= FF_HABER(Z2,Y2)+XYD*BP(Y2,Z2)+XYD**2*HP2(Y2,Z2)
     .    +XYD**3*HP3(Y2,Z2)
      RETURN
  100 WRITE(6,200)
  200 FORMAT(1X,'ERROR: ARGUMENTS OF HP-FUNCTION MUST BE POSITIVE')
      END
C
      FUNCTION FP1(Y2,Z2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      YZD= (Y2-Z2)/Z2
      DYZD= DABS(YZD)
      IF (DYZD .LT. SMALL) GO TO 50
      FP1= 0.5D0*(5.D0*Y2+Z2)/(Y2-Z2)**3
     1         -Y2*(2.D0*Z2+Y2)*DLOG(Y2/Z2)/(Y2-Z2)**4
      RETURN
   50 FP1=(-1.D0/12.D0+YZD/15.D0-YZD**2/20.D0+4.D0*YZD**3/105.D0)/Z2**2
      RETURN
      END
C
      FUNCTION FP2(Y2,Z2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      YZD= (Y2-Z2)/Z2
      DYZD= DABS(YZD)
      IF (DYZD .LT. SMALL) GO TO 50
      FP2= (Z2**2-8.D0*Z2*Y2-17.D0*Y2**2)/(6.D0*(Y2-Z2)**4)
     1         +Y2**2*(3.D0*Z2+Y2)*DLOG(Y2/Z2)/(Y2-Z2)**5
      RETURN
   50 FP2=(1.D0/20.D0-YZD/30.D0+3.D0*YZD**2/140.D0+YZD**3/70.D0)/Z2**2
      RETURN
      END

      FUNCTION FP3(Y2,Z2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      YZD= (Y2-Z2)/Z2
      DYZD= DABS(YZD)
      IF (DYZD .LT. SMALL) GO TO 50
      POLY= Z2**3-7.D0*Z2**2*Y2+29.D0*Z2*Y2**2+37.D0*Y2**3
      FP3= POLY/(12.D0*(Y2-Z2)**5)
     1         -Y2**3*(4.D0*Z2+Y2)*DLOG(Y2/Z2)/(Y2-Z2)**6
      RETURN
   50 FP3=(-1.D0/30.D0+2.D0*YZD/105.D0-3.D0*YZD**2/280.D0
     1         +2.D0*YZD**3/315.D0)/Z2**2
      RETURN
      END
C
      FUNCTION HP2(Y2,Z2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      YZD= (Y2-Z2)/Z2
      DYZD= DABS(YZD)
      IF (DYZD .LT. SMALL) GO TO 50
      HP2= (Z2**2-5.D0*Z2*Y2-2.D0*Y2**2)/(6.D0*(Y2-Z2)**3)
     1         +Y2**2*Z2*DLOG(Y2/Z2)/(Y2-Z2)**4
      RETURN
   50 HP2=(-1.D0/12.D0+YZD/30.D0-YZD**2/60.D0+YZD**3/105.D0)/Z2
      RETURN
      END
C
      FUNCTION HP3(Y2,Z2)
      IMPLICIT REAL*8(A-H,O-Z)
      DATA SMALL/1.D-4/
      YZD= (Y2-Z2)/Z2
      DYZD= DABS(YZD)
      IF (DYZD .LT. SMALL) GO TO 50
      POLY= Z2**3-5.D0*Z2**2*Y2+13.D0*Z2*Y2**2+3.D0*Y2**3
      HP3= POLY/(12.D0*(Y2-Z2)**4)
     1         -Y2**3*Z2*DLOG(Y2/Z2)/(Y2-Z2)**5
      RETURN
   50 HP3=(1.D0/20.D0-YZD/60.D0+YZD**2/140.D0-YZD**3/280.D0)/Z2
      RETURN
      END

      FUNCTION ALFS(QK)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/QMASS/ TMPOLE
      DATA PI/3.1415926535D0/
C
C   ONE-LOOP STRONG COUPLING FOR QK>BMASS
C
      AST= 0.11D0
      ALFS= AST
      IF (QK .GE. TMPOLE) F= 6.D0
      IF (QK .LT. TMPOLE) F= 5.D0
      IF (QK .LT. 5.D0) GO TO 10
      DEN= 1.D0+AST*(11.D0-2.D0*F/3.D0)*DLOG(QK/TMPOLE)/(2.D0*PI)
      ALFS= AST/DEN
      RETURN
   10 WRITE (6,100)
  100 FORMAT(1X,'ERROR: STRONG COUPLING CONSTANT EVALUATED BELOW M(B)')
      RETURN
      END

      FUNCTION TMASSR(Q,TMASS)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/QMASS/ TMPOLE
      DATA PI/3.1415926535/
      QP= TMPOLE
      HB2= 0.5D0*G2*BMASS**2/(WMASS*COSB)**2
      HT2= 0.5D0*G2*TMASS**2/(WMASS*SINB)**2
      ALS= ALFS(QP)
      ALST= ALS-3.D0*HT2/(64.D0*PI)
     1          +GP2/(48.D0*PI)
     2          -HB2/(64.D0*PI)
      TMASSR= TMASS*(1.D0-ALST*DLOG(Q**2/TMASS**2)/PI)
      RETURN
      END

      SUBROUTINE HIGGS3(IRC,H,DL)
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON ZMASS,WMASS,SINW2,ALPHA,BMASS,G2,GP2,SINB,COSB,COTB
      COMMON/ANG/ SINA,COSA,SIN2A,COS2A,SINBPA,COSBPA,SINBMA,COSBMA
      COMMON/HINT3/HLAA,HHAA,HLHLHL,HHHLHL,HHHHHL,HHHHHH,
     1      HHHPHM,HLHPHM
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      DOUBLE PRECISION LA1,LA2,LA3,LA4,LA5,LA6,LA7
      COMMON/HSELF_HDEC/LA1,LA2,LA3,LA4,LA5,LA6,LA7
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      DIMENSION H(4),DL(7)
      DATA PI/3.1415926535D0/
C
C   DL(3)= LAMBDA(3)+LAMBDA(4)
C   DL(4)= LAMBDA(5)-LAMBDA(4)
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      LA1 = DL(1)
      LA2 = DL(2)
      LA4 = DL(5)-DL(4)
      LA3 = DL(3)-LA4
      LA5 = DL(5)
      LA6 = DL(6)
      LA7 = DL(7)
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      V2= 4.D0*WMASS**2/G2
      DL4NL= 2.D0*(H(4)**2-H(3)**2)/V2
      COSW= DSQRT(1.D0-SINW2)
      G= DSQRT(G2)
      SINB2= SINB**2
      COSB2= COSB**2
      SINA2= SINA**2
      COSA2= COSA**2
      SINA3= SINA**3
      COSA3= COSA**3
      COS2B= COSB2-SINB2
      IF (IRC .EQ. 0) GO TO 50
      FACN= 2.D0*WMASS/G
      HLAA= FACN*(DL(1)*SINA*COSB*SINB2-DL(2)*COSA*SINB*COSB2
     1        -(DL(3)+DL(5))*(COSA*SINB**3-SINA*COSB**3)
     2        +2.D0*DL(5)*SINBMA-DL(6)*SINB*(COSB*SINBPA+SINA*COS2B)
     3        -DL(7)*COSB*(COSA*COS2B-SINB*SINBPA))
      HHAA= -FACN*(DL(1)*COSA*COSB*SINB2+DL(2)*SINA*SINB*COSB2
     1        +(DL(3)+DL(5))*(SINA*SINB**3+COSA*COSB**3)
     2        -2.D0*DL(5)*COSBMA-DL(6)*SINB*(COSB*COSBPA+COSA*COS2B)
     3        +DL(7)*COSB*(SINB*COSBPA+SINA*COS2B))
      HHHLHL= -3.D0*FACN*(DL(1)*COSA*SINA2*COSB+DL(2)*SINA*COSA2*SINB
     1        +(DL(3)+DL(5))*(SINA3*SINB+COSA3*COSB-2.D0*COSBMA/3.D0)
     2        -DL(6)*SINA*(COSB*COS2A+COSA*COSBPA)
     3        +DL(7)*COSA*(SINB*COS2A+SINA*COSBPA))
      HHHHHL= 3.D0*FACN*(DL(1)*SINA*COSB*COSA2-DL(2)*COSA*SINB*SINA2
     1        +(DL(3)+DL(5))*(SINA3*COSB-COSA3*SINB+2.D0*SINBMA/3.D0)
     2        -DL(6)*COSA*(COSB*COS2A-SINA*SINBPA)
     3        -DL(7)*SINA*(SINB*COS2A+COSA*SINBPA))
      HHHHHH= -3.D0*FACN*(DL(1)*COSB*COSA3+DL(2)*SINB*SINA3
     1        +(DL(3)+DL(5))*SINA*COSA*SINBPA
     2        +DL(6)*COSA2*(3.D0*SINA*COSB+COSA*SINB)
     3        +DL(7)*SINA2*(3.D0*COSA*SINB+SINA*COSB))
      HLHLHL= 3.D0*FACN*(DL(1)*COSB*SINA3-DL(2)*SINB*COSA3
     1        +(DL(3)+DL(5))*SINA*COSA*COSBPA
     2        -DL(6)*SINA2*(3.D0*COSA*COSB-SINA*SINB)
     3        +DL(7)*COSA2*(3.D0*SINA*SINB-COSA*COSB))
      HHHPHM= HHAA-FACN*COSBMA*DL(4)
      HLHPHM= HLAA-FACN*SINBMA*DL(4)
C
C   THESE COUPLINGS INCLUDE NON-LEADING LOG CONTRIBUTIONS
C   WHICH ARE TAKEN TO BE THE SAME AS IN THE CORRECTIONS
C   TO THE CHARGED HIGGS MASS SQUARED.
C
C     HHHPM= HHAA-FACN*COSBMA*DL4NL
C     HLHPM= HLAA-FACN*SINBMA*DL4NL
      RETURN
   50 FAC= -G*WMASS
      FAN= -0.5D0*G*ZMASS/COSW
      HHHPHM= FAC*COSBMA-FAN*COS2B*COSBPA
      HLHPHM= FAC*SINBMA+FAN*COS2B*SINBPA
      HHHHHH= 3.D0*FAN*COS2A*COSBPA
      HLHLHL= 3.D0*FAN*COS2A*SINBPA
      HHHHHL= -FAN*(2.D0*SIN2A*COSBPA+COS2A*SINBPA)
      HHHLHL= FAN*(2.D0*SIN2A*SINBPA-COS2A*COSBPA)
      HHAA= -FAN*COS2B*COSBPA
      HLAA= FAN*COS2B*SINBPA
      RETURN
      END
