!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
!  
!  Differentiation of adjustinflowangleforcesadj in reverse (adjoint) mode:
!   gradient, with respect to input variables: alphaadj betaadj
!   of linear combination of output variables: liftdirectionadj
!                veldirfreestreamadj
!
!      ******************************************************************
!      *                                                                *
!      * File:          adjustInflowAngleAdj.f90                        *
!      * Author:        C.A.(Sandy) Mader                               *
!      * Starting date: 05-14-2008                                      *
!      * Last modified: 05-14-2008                                      *
!      *                                                                *
!      ******************************************************************
!
SUBROUTINE ADJUSTINFLOWANGLEFORCESADJ_B(alphaadj, alphaadjb, betaadj, &
&  betaadjb, veldirfreestreamadj, veldirfreestreamadjb, liftdirectionadj&
&  , liftdirectionadjb, dragdirectionadj, liftindex)
  USE constants
  IMPLICIT NONE
!!      call getDirVectorForces(zero, one, zero, alphaAdj, betaAdj, &
!           temp1, &
!           temp2, &
!           temp3!)
!      liftDirectionAdj(1)= temp1
!      liftDirectionAdj(2)= temp2
!      liftDirectionAdj(3)= temp3
  REAL(KIND=REALTYPE) :: alphaadj, alphaadjb, betaadj, betaadjb
  REAL(KIND=REALTYPE) :: dragdirectionadj(3)
  REAL(KIND=REALTYPE) :: liftdirectionadj(3), liftdirectionadjb(3)
  INTEGER(KIND=INTTYPE) :: liftindex
  REAL(KIND=REALTYPE) :: veldirfreestreamadj(3), veldirfreestreamadjb(3)
  REAL(KIND=REALTYPE) :: refdirection(3)
  REAL(KIND=REALTYPE) :: temp1, temp2, temp3
!Subroutine Vars
!Local Vars
!Begin Execution
! Velocity direction given by the rotation of a unit vector
! initially aligned along the positive x-direction (1,0,0)
! 1) rotate alpha radians cw about z-axis
! 2) rotate beta radians ccw about y-axis
!temp1 = velDirFreestreamAdj(1)
!temp2 = velDirFreestreamAdj(2)
!temp3 = velDirFreestreamAdj(3)
!      call getDirVector(one, zero, zero, alphaAdj, betaAdj, &
!                        velDirFreestreamAdj(1), &
!                        velDirFreestreamAdj(2), &
!                        velDirFreestreamAdj(3))
  refdirection(:) = zero
  refdirection(1) = one
  CALL GETDIRVECTORFORCES(refdirection, alphaadj, betaadj, &
&                    veldirfreestreamadj, liftindex)
  CALL PUSHREAL8ARRAY(refdirection, 3)
!      call getDirVectorForces(one, zero, zero, alphaAdj, betaAdj, &
!           temp1, &
!!           temp2, &
!           temp3)
!!      velDirFreestreamAdj(1) = temp1
!      velDirFreestreamAdj(2) = temp2
!      velDirFreestreamAdj(3) = temp3
! Drag direction given by the rotation of a unit vector
! initially aligned along the positive x-direction (1,0,0)
! 1) rotate alpha radians cw about z-axis
! 2) rotate beta radians ccw about y-axis
!      call getDirVector(one, zero, zero, alphaAdj, betaAdj,   &
!                        dragDirectionAdj(1), dragDirectionAdj(2), &
!                        dragDirectionAdj(3))
!temp1 = dragDirectionAdj(1)
!temp2 = dragDirectionAdj(2)
!temp3 = dragDirectionAdj(3)
  refdirection(:) = zero
  CALL PUSHREAL8(refdirection(1))
  refdirection(1) = one
  CALL GETDIRVECTORFORCES(refdirection, alphaadj, betaadj, &
&                    dragdirectionadj(1), liftindex)
  CALL PUSHREAL8ARRAY(refdirection, 3)
!      call getDirVectorForces(one, zero, zero, alphaAdj, betaAdj, &
!           temp1, &
!           temp2, &
!           temp3)!
!
!      dragDirectionAdj(1)= temp1
!      dragDirectionAdj(2)= temp2
!      dragDirectionAdj(3)= temp3
! Lift direction given by the rotation of a unit vector
! initially aligned along the positive z-direction (0,0,1)
! 1) rotate alpha radians cw about z-axis
! 2) rotate beta radians ccw about y-axis
!      call getDirVector(zero,one, zero, alphaAdj, betaAdj,   &
!                        liftDirectionAdj(1), liftDirectionAdj(2), &
!                        liftDirectionAdj(3))
!temp1 = liftDirectionAdj(1)
!temp2 = liftDirectionAdj(2)
!temp3 = liftDirectionAdj(3)
  refdirection(:) = zero
  CALL PUSHREAL8(refdirection(liftindex))
  refdirection(liftindex) = one
  betaadjb = 0.0
  alphaadjb = 0.0
  CALL GETDIRVECTORFORCES_B(refdirection, alphaadj, alphaadjb, betaadj, &
&                      betaadjb, liftdirectionadj, liftdirectionadjb, &
&                      liftindex)
  CALL POPREAL8(refdirection(liftindex))
  CALL POPREAL8ARRAY(refdirection, 3)
  CALL POPREAL8(refdirection(1))
  CALL POPREAL8ARRAY(refdirection, 3)
  CALL GETDIRVECTORFORCES_B(refdirection, alphaadj, alphaadjb, betaadj, &
&                      betaadjb, veldirfreestreamadj, &
&                      veldirfreestreamadjb, liftindex)
END SUBROUTINE ADJUSTINFLOWANGLEFORCESADJ_B
