!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
module initializeflow_d
  use constants, only : inttype, realtype, maxstringlen
  implicit none
! ----------------------------------------------------------------------
!                                                                      |
!                    no tapenade routine below this line               |
!                                                                      |
! ----------------------------------------------------------------------
  save 

contains
!  differentiation of referencestate in forward (tangent) mode (with options i4 dr8 r8):
!   variations   of useful results: gammainf pinf timeref rhoinf
!                muref tref winf pinfcorr rgas pref
!   with respect to varying inputs: mach veldirfreestream machcoef
!                tinfdim rhoinfdim pinfdim
  subroutine referencestate_d()
!
!       the original version has been nuked since the computations are
!       no longer necessary when calling from python
!       this is the most compliclated routine in all of sumb. it is
!       stupidly complicated. this is most likely the reason your
!       derivatives are wrong. you don't understand this routine
!       and its effects.
!       this routine *requries* the following as input:
!       mach, pinfdim, tinfdim, rhoinfdim, rgasdim (machcoef non-sa
!        turbulence only)
!       optionally, pref, rhoref and tref are used if they are
!       are non-negative. this only happens when you want the equations
!       normalized by values other than the freestream
!      * this routine computes as output:
!      *   muinfdim, (unused anywhere in code)
!         pref, rhoref, tref, muref, timeref ('dimensional' reference)
!         pinf, pinfcorr, rhoinf, uinf, rgas, muinf, gammainf and winf
!         (non-dimensionalized values used in actual computations)
!
    use constants
    use paramturb
    use inputphysics, only : equations, mach, machd, machcoef, &
&   machcoefd, musuthdim, tsuthdim, veldirfreestream, veldirfreestreamd,&
&   rgasdim, ssuthdim, eddyvisinfratio, turbmodel, turbintensityinf
    use flowvarrefstate, only : pinfdim, pinfdimd, tinfdim, tinfdimd, &
&   rhoinfdim, rhoinfdimd, muinfdim, muinfdimd, pref, prefd, rhoref, &
&   rhorefd, tref, trefd, muref, murefd, timeref, timerefd, pinf, pinfd,&
&   pinfcorr, pinfcorrd, rhoinf, rhoinfd, uinf, uinfd, rgas, rgasd, &
&   muinf, muinfd, gammainf, gammainfd, winf, winfd, nw, nwf, kpresent, &
&   winf, winfd
    use flowutils_d, only : computegamma, computegamma_d, etot, etot_d
    use turbutils_d, only : sanuknowneddyratio, sanuknowneddyratio_d
    implicit none
    integer(kind=inttype) :: sps, nn, mm, ierr
    real(kind=realtype) :: gm1, ratio
    real(kind=realtype) :: nuinf, ktmp, uinf2
    real(kind=realtype) :: nuinfd, ktmpd, uinf2d
    real(kind=realtype) :: vinf, zinf, tmp1(1), tmp2(1)
    real(kind=realtype) :: vinfd, zinfd, tmp1d(1), tmp2d(1)
    intrinsic sqrt
    real(kind=realtype) :: arg1
    real(kind=realtype) :: arg1d
    real(kind=realtype) :: result1
    real(kind=realtype) :: result1d
! compute the dimensional viscosity from sutherland's law
    muinfdimd = musuthdim*((tsuthdim+ssuthdim)*1.5_realtype*(tinfdim/&
&     tsuthdim)**0.5*tinfdimd/((tinfdim+ssuthdim)*tsuthdim)-(tsuthdim+&
&     ssuthdim)*tinfdimd*(tinfdim/tsuthdim)**1.5_realtype/(tinfdim+&
&     ssuthdim)**2)
    muinfdim = musuthdim*((tsuthdim+ssuthdim)/(tinfdim+ssuthdim))*(&
&     tinfdim/tsuthdim)**1.5_realtype
! set the reference values. they *could* be different from the
! free-stream values for an internal flow simulation. for now,
! we just use the actual free stream values.
    prefd = pinfdimd
    pref = pinfdim
    trefd = tinfdimd
    tref = tinfdim
    rhorefd = rhoinfdimd
    rhoref = rhoinfdim
! compute the value of muref, such that the nondimensional
! equations are identical to the dimensional ones.
! note that in the non-dimensionalization of muref there is
! a reference length. however this reference length is 1.0
! in this code, because the coordinates are converted to
! meters.
    if (pref*rhoref .eq. 0.0_8) then
      murefd = 0.0_8
    else
      murefd = (prefd*rhoref+pref*rhorefd)/(2.0*sqrt(pref*rhoref))
    end if
    muref = sqrt(pref*rhoref)
! compute timeref for a correct nondimensionalization of the
! unsteady equations. some story as for the reference viscosity
! concerning the reference length.
    if (rhoref/pref .eq. 0.0_8) then
      timerefd = 0.0_8
    else
      timerefd = (rhorefd*pref-rhoref*prefd)/(pref**2*2.0*sqrt(rhoref/&
&       pref))
    end if
    timeref = sqrt(rhoref/pref)
! compute the nondimensional pressure, density, velocity,
! viscosity and gas constant.
    pinfd = (pinfdimd*pref-pinfdim*prefd)/pref**2
    pinf = pinfdim/pref
    rhoinfd = (rhoinfdimd*rhoref-rhoinfdim*rhorefd)/rhoref**2
    rhoinf = rhoinfdim/rhoref
    arg1d = (gammainf*pinfd*rhoinf-gammainf*pinf*rhoinfd)/rhoinf**2
    arg1 = gammainf*pinf/rhoinf
    if (arg1 .eq. 0.0_8) then
      result1d = 0.0_8
    else
      result1d = arg1d/(2.0*sqrt(arg1))
    end if
    result1 = sqrt(arg1)
    uinfd = machd*result1 + mach*result1d
    uinf = mach*result1
    rgasd = (rgasdim*(rhorefd*tref+rhoref*trefd)*pref-rgasdim*rhoref*&
&     tref*prefd)/pref**2
    rgas = rgasdim*rhoref*tref/pref
    muinfd = (muinfdimd*muref-muinfdim*murefd)/muref**2
    muinf = muinfdim/muref
    tmp1d = 0.0_8
    tmp1d(1) = tinfdimd
    tmp1(1) = tinfdim
    call computegamma_d(tmp1, tmp1d, tmp2, tmp2d, 1)
    gammainfd = tmp2d(1)
    gammainf = tmp2(1)
! ----------------------------------------
!      compute the final winf
! ----------------------------------------
! allocate the memory for winf if necessary
! zero out the winf first
    winf(:) = zero
! set the reference value of the flow variables, except the total
! energy. this will be computed at the end of this routine.
    winfd = 0.0_8
    winfd(irho) = rhoinfd
    winf(irho) = rhoinf
    winfd(ivx) = uinfd*veldirfreestream(1) + uinf*veldirfreestreamd(1)
    winf(ivx) = uinf*veldirfreestream(1)
    winfd(ivy) = uinfd*veldirfreestream(2) + uinf*veldirfreestreamd(2)
    winf(ivy) = uinf*veldirfreestream(2)
    winfd(ivz) = uinfd*veldirfreestream(3) + uinf*veldirfreestreamd(3)
    winf(ivz) = uinf*veldirfreestream(3)
! compute the velocity squared based on machcoef. this gives a
! better indication of the 'speed' of the flow so the turubulence
! intensity ration is more meaningful especially for moving
! geometries. (not used in sa model)
    uinf2d = (((machcoefd*machcoef+machcoef*machcoefd)*gammainf*pinf+&
&     machcoef**2*(gammainfd*pinf+gammainf*pinfd))*rhoinf-machcoef**2*&
&     gammainf*pinf*rhoinfd)/rhoinf**2
    uinf2 = machcoef*machcoef*gammainf*pinf/rhoinf
! set the turbulent variables if transport variables are to be
! solved. we should be checking for rans equations here,
! however, this code is included in block res. the issue is
! that for frozen turbulence (or ank jacobian) we call the
! block_res with equationtype set to laminar even though we are
! actually solving the rans equations. the issue is that, the
! freestream turb variables will be changed to zero, thus
! changing the solution. insteady we check if nw > nwf which
! will accomplish the same thing.
    if (nw .gt. nwf) then
      nuinfd = (muinfd*rhoinf-muinf*rhoinfd)/rhoinf**2
      nuinf = muinf/rhoinf
      select case  (turbmodel) 
      case (spalartallmaras, spalartallmarasedwards) 
        winfd(itu1) = sanuknowneddyratio_d(eddyvisinfratio, nuinf, &
&         nuinfd, winf(itu1))
      case (komegawilcox, komegamodified, mentersst) 
!=============================================================
        winfd(itu1) = 1.5_realtype*turbintensityinf**2*uinf2d
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winfd(itu2) = (winfd(itu1)*eddyvisinfratio*nuinf-winf(itu1)*&
&         eddyvisinfratio*nuinfd)/(eddyvisinfratio*nuinf)**2
        winf(itu2) = winf(itu1)/(eddyvisinfratio*nuinf)
      case (ktau) 
!=============================================================
        winfd(itu1) = 1.5_realtype*turbintensityinf**2*uinf2d
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winfd(itu2) = (eddyvisinfratio*nuinfd*winf(itu1)-eddyvisinfratio&
&         *nuinf*winfd(itu1))/winf(itu1)**2
        winf(itu2) = eddyvisinfratio*nuinf/winf(itu1)
      case (v2f) 
!=============================================================
        winfd(itu1) = 1.5_realtype*turbintensityinf**2*uinf2d
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winfd(itu2) = (0.09_realtype*2*winf(itu1)*winfd(itu1)*&
&         eddyvisinfratio*nuinf-0.09_realtype*winf(itu1)**2*&
&         eddyvisinfratio*nuinfd)/(eddyvisinfratio*nuinf)**2
        winf(itu2) = 0.09_realtype*winf(itu1)**2/(eddyvisinfratio*nuinf)
        winfd(itu3) = 0.666666_realtype*winfd(itu1)
        winf(itu3) = 0.666666_realtype*winf(itu1)
        winfd(itu4) = 0.0_8
        winf(itu4) = 0.0_realtype
      end select
    end if
! set the value of pinfcorr. in case a k-equation is present
! add 2/3 times rho*k.
    pinfcorrd = pinfd
    pinfcorr = pinf
    if (kpresent) then
      pinfcorrd = pinfd + two*third*(rhoinfd*winf(itu1)+rhoinf*winfd(&
&       itu1))
      pinfcorr = pinf + two*third*rhoinf*winf(itu1)
    end if
! compute the free stream total energy.
    ktmp = zero
    if (kpresent) then
      ktmpd = winfd(itu1)
      ktmp = winf(itu1)
    else
      ktmpd = 0.0_8
    end if
    vinf = zero
    zinf = zero
    zinfd = 0.0_8
    vinfd = 0.0_8
    call etot_d(rhoinf, rhoinfd, uinf, uinfd, vinf, vinfd, zinf, zinfd, &
&         pinfcorr, pinfcorrd, ktmp, ktmpd, winf(irhoe), winfd(irhoe), &
&         kpresent)
  end subroutine referencestate_d
  subroutine referencestate()
!
!       the original version has been nuked since the computations are
!       no longer necessary when calling from python
!       this is the most compliclated routine in all of sumb. it is
!       stupidly complicated. this is most likely the reason your
!       derivatives are wrong. you don't understand this routine
!       and its effects.
!       this routine *requries* the following as input:
!       mach, pinfdim, tinfdim, rhoinfdim, rgasdim (machcoef non-sa
!        turbulence only)
!       optionally, pref, rhoref and tref are used if they are
!       are non-negative. this only happens when you want the equations
!       normalized by values other than the freestream
!      * this routine computes as output:
!      *   muinfdim, (unused anywhere in code)
!         pref, rhoref, tref, muref, timeref ('dimensional' reference)
!         pinf, pinfcorr, rhoinf, uinf, rgas, muinf, gammainf and winf
!         (non-dimensionalized values used in actual computations)
!
    use constants
    use paramturb
    use inputphysics, only : equations, mach, machcoef, musuthdim, &
&   tsuthdim, veldirfreestream, rgasdim, ssuthdim, eddyvisinfratio, &
&   turbmodel, turbintensityinf
    use flowvarrefstate, only : pinfdim, tinfdim, rhoinfdim, muinfdim,&
&   pref, rhoref, tref, muref, timeref, pinf, pinfcorr, rhoinf, uinf, &
&   rgas, muinf, gammainf, winf, nw, nwf, kpresent, winf
    use flowutils_d, only : computegamma, etot
    use turbutils_d, only : sanuknowneddyratio
    implicit none
    integer(kind=inttype) :: sps, nn, mm, ierr
    real(kind=realtype) :: gm1, ratio
    real(kind=realtype) :: nuinf, ktmp, uinf2
    real(kind=realtype) :: vinf, zinf, tmp1(1), tmp2(1)
    intrinsic sqrt
    real(kind=realtype) :: arg1
    real(kind=realtype) :: result1
! compute the dimensional viscosity from sutherland's law
    muinfdim = musuthdim*((tsuthdim+ssuthdim)/(tinfdim+ssuthdim))*(&
&     tinfdim/tsuthdim)**1.5_realtype
! set the reference values. they *could* be different from the
! free-stream values for an internal flow simulation. for now,
! we just use the actual free stream values.
    pref = pinfdim
    tref = tinfdim
    rhoref = rhoinfdim
! compute the value of muref, such that the nondimensional
! equations are identical to the dimensional ones.
! note that in the non-dimensionalization of muref there is
! a reference length. however this reference length is 1.0
! in this code, because the coordinates are converted to
! meters.
    muref = sqrt(pref*rhoref)
! compute timeref for a correct nondimensionalization of the
! unsteady equations. some story as for the reference viscosity
! concerning the reference length.
    timeref = sqrt(rhoref/pref)
! compute the nondimensional pressure, density, velocity,
! viscosity and gas constant.
    pinf = pinfdim/pref
    rhoinf = rhoinfdim/rhoref
    arg1 = gammainf*pinf/rhoinf
    result1 = sqrt(arg1)
    uinf = mach*result1
    rgas = rgasdim*rhoref*tref/pref
    muinf = muinfdim/muref
    tmp1(1) = tinfdim
    call computegamma(tmp1, tmp2, 1)
    gammainf = tmp2(1)
! ----------------------------------------
!      compute the final winf
! ----------------------------------------
! allocate the memory for winf if necessary
! zero out the winf first
    winf(:) = zero
! set the reference value of the flow variables, except the total
! energy. this will be computed at the end of this routine.
    winf(irho) = rhoinf
    winf(ivx) = uinf*veldirfreestream(1)
    winf(ivy) = uinf*veldirfreestream(2)
    winf(ivz) = uinf*veldirfreestream(3)
! compute the velocity squared based on machcoef. this gives a
! better indication of the 'speed' of the flow so the turubulence
! intensity ration is more meaningful especially for moving
! geometries. (not used in sa model)
    uinf2 = machcoef*machcoef*gammainf*pinf/rhoinf
! set the turbulent variables if transport variables are to be
! solved. we should be checking for rans equations here,
! however, this code is included in block res. the issue is
! that for frozen turbulence (or ank jacobian) we call the
! block_res with equationtype set to laminar even though we are
! actually solving the rans equations. the issue is that, the
! freestream turb variables will be changed to zero, thus
! changing the solution. insteady we check if nw > nwf which
! will accomplish the same thing.
    if (nw .gt. nwf) then
      nuinf = muinf/rhoinf
      select case  (turbmodel) 
      case (spalartallmaras, spalartallmarasedwards) 
        winf(itu1) = sanuknowneddyratio(eddyvisinfratio, nuinf)
      case (komegawilcox, komegamodified, mentersst) 
!=============================================================
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winf(itu2) = winf(itu1)/(eddyvisinfratio*nuinf)
      case (ktau) 
!=============================================================
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winf(itu2) = eddyvisinfratio*nuinf/winf(itu1)
      case (v2f) 
!=============================================================
        winf(itu1) = 1.5_realtype*uinf2*turbintensityinf**2
        winf(itu2) = 0.09_realtype*winf(itu1)**2/(eddyvisinfratio*nuinf)
        winf(itu3) = 0.666666_realtype*winf(itu1)
        winf(itu4) = 0.0_realtype
      end select
    end if
! set the value of pinfcorr. in case a k-equation is present
! add 2/3 times rho*k.
    pinfcorr = pinf
    if (kpresent) pinfcorr = pinf + two*third*rhoinf*winf(itu1)
! compute the free stream total energy.
    ktmp = zero
    if (kpresent) ktmp = winf(itu1)
    vinf = zero
    zinf = zero
    call etot(rhoinf, uinf, vinf, zinf, pinfcorr, ktmp, winf(irhoe), &
&       kpresent)
  end subroutine referencestate
end module initializeflow_d
