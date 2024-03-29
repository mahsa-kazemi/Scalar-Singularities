#################################################
# Singularity library                           #
# File:SingularityLibrary.mm                    #
# Last update:                                  #
#               18 September 2013               #
#               18 November 2015                #
#               15 Fubruary 2017                #
#               14 August   2017                #
#               24 Jan      2018                #
#               28 Feb      2018                #
#               09  March   2018                # 
#    Contact:                                   #
#    Majid Gazor <mgazor@cc.iut.ac.ir>          #
#    Mahsa Kazemi <mahsa.kazemi@math.iut.ac.ir> #
#################################################
with(RegularChains):with(ChainTools):with(SemiAlgebraicSetTools):with(LinearAlgebra):with(Groebner):with(Ore_algebra):with(PolynomialIdeals):with(combinat):with(plots):
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
# Local Monomial Orderings:
# 1- Ds : Anti graded lexicographical ordering;
Ds := proc (u, v) 
global var; 
	if degree(v) < degree(u) then 
		RETURN(true); 
	end if; 
	if degree(u) < degree(v) then 
		RETURN(false); 
	else 
		RETURN(TestOrder(u, v, plex(op(var)))); 
	end if; 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
# 2- ls : Anti lexicographical ordering; 
ls := proc (u, v) 
global var; 
	RETURN(TestOrder(v, u, plex(op(var)))); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
# 3- ds : Anti graded reverse lexicographical ordering;
ds := proc (u, v) 
global var; 
	if degree(v) < degree(u) then 
		RETURN(true); 
	end if: 
	if degree(u) < degree(v) then 
		RETURN(false); 
	else 
		RETURN(TestOrder(u, v, tdeg(op(var)))); 
	end if: 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
# Preliminaries:
MonomialMaker:= proc (d,vars) 
options operator, arrow; 
	op(randpoly(vars, degree = d, dense, homogeneous, coeffs = proc () 1 end proc)); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
MonomialMakerSpecial:= proc (d,V) 
options operator, arrow; 
	op(randpoly(V, degree = d, dense, homogeneous, coeffs = proc () 1 end proc)); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
LC := proc (f) 
global t; 
	RETURN(LeadingCoefficient(f, t)); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
LM := proc (f) 
global t; 
	RETURN(LeadingMonomial(f, t)); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
ecart := proc (f) 
global t; 
	RETURN(degree(f)-degree(LM(f))); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SelFun := proc (g) 
	if divide(LM(h), LM(g)) then 
		RETURN(true); 
	end if; 
	RETURN(false); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#note : I have to make sure about vars or var
#>-----------------------------------------------------------------------------
Refine:=proc(h)
#option trace;
global var;
local Fac,fac,S;
#I changed vars to be var here:next line
	if expand(LeadingMonomial(h,plex(op(var)))*LeadingCoefficient(h,plex(op(var))))=h then
		RETURN(h);
	fi;
#if simplify(h,var)=0 then
#    RETURN(h);
#fi;
	Fac := [seq(g, g = factor(h))];
	S:=1;
	for fac in Fac do
		if simplify(fac,var)=0 then
			S:=S*fac;
		fi;
	od;
	RETURN(S);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
### The Main Procedure ########

MoraNF := proc (f, F) 
local A, ff, L, M, g, SortFun; 
global var, t,h; 
    #option trace; 
    #d:=degree(f);
	h := f; 
	L := F; 
	M := select(SelFun, L); 
	SortFun := proc (p, q) 
	global t;
		if ecart(p) < ecart(q) or (ecart(p) = ecart(q) and TestOrder(LM(p),LM(q),t)) then 
			RETURN(true): 
		end if; 
		RETURN(false); 
end proc:
while nops(M) <> 0 and h <> 0 do
	M := sort(M, SortFun); 
	g := M[1]; 
	if ecart(h) < ecart(g) then 
		L := [h,op(L)]; 
	end if; 
	h := simplify(h-LC(h, T)*LM(h, T)*g/(LC(g, T)*LM(g, T))); 
	h:=Refine(h);
	#if degree(h)> d then print(h); fi;
		if h <> 0 then 
			M := select(SelFun, L); 
		end if; 
end do; 
RETURN(h): 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
## An Easy Example:
#print("An Easy Example:  MoraNF(x^2*lambda-x*lambda, [x*x, x*lambda-lambda], [x, lambda], ls)");
#MoraNF(x^2*lambda-x*lambda, [x*x, x*lambda-lambda], [x, lambda], ls);


LT:=proc(f,t) 
	RETURN(LeadingTerm(f,t)[2]): 
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
f2:=proc(i,j)
global t,Moshkel:
	RETURN(TestOrder(lcm(Moshkel[i[1]][2],Moshkel[i[2]][2]),lcm(Moshkel[j[1]][2],Moshkel[j[2]][2]),t));
 end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UPDATE:=proc(G0,B0,h)
#option trace:
global Moshkel,t:
local E,G1,BB,L1,L2,L4,i,flag,lth,j:
	lth:=Moshkel[h][2]:
	L1:=G0:L2:=[]:flag:=true:
	for i in L1 do
		if gcd(lth,Moshkel[i][2])=1 then
			L2:=[op(L2),i]:
			L1:=[op({op(L1)} minus {i})]:
		fi:
	od:
	for i in L1 do
		L1:=[op({op(L1)} minus {i})]:
		for j in L1 while flag=true do
			if divide(lcm(lth,Moshkel[i][2]),lcm(lth,Moshkel[j][2])) then
				flag:=false:
			fi:
		od:
		for j in L2 while flag=true do
			if divide(lcm(lth,Moshkel[i][2]),lcm(lth,Moshkel[j][2])) then
				flag:=false:
			fi:
		od:
		if flag=true then
			L2:=[op(L2),i]:
		fi:
		flag:=true:
	od:
	E:=[]:
	for i in L2 do
		if gcd(lth,Moshkel[i][2])<>1 then
			E:=[op(E),i]:
		fi:
	od:
	L4:=[]:BB:=sort(B0,f2):
	for i from 1 to nops(BB) do
		if
			divide(lcm(Moshkel[BB[i][1]][2],Moshkel[BB[i][2]][2]),lth)=false or
			lcm(Moshkel[BB[i][1]][2],lth)=lcm(Moshkel[BB[i][1]][2],Moshkel[BB[i][2]][2])or
			lcm(lth,Moshkel[BB[i][2]][2])= lcm(Moshkel[BB[i][1]][2],Moshkel[BB[i][2]][2]) then
			L4:=[op(L4),i]:
		fi:
	od: 
	G1:=[]:
	for i in G0 do
		if divide(Moshkel[i][2],lth)=false then
			G1:=[op(G1),i]:
		fi:
	od:
	G1:=[op(G1),h]:
	E:=sort([seq([h,i],i in E),seq(B0[i],i in L4)],f2):
	RETURN(G1,E):
end:
 #<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
 STD:=proc(FFF,V,Tord)
 #option trace:
global Moshkel,t,var: 
local A,G,B,f,F,p,rds,m,n,i,w,H,FF:
	m:=kernelopts(bytesused,cputime):
	FF:=[op({op(FFF)} minus {0})];
	var := V; 
	A := poly_algebra(op(var)); 
	t := MonomialOrder(A, ('user')(Tord, var));
	Moshkel:=[seq([f,LT(f,t)],f in FF)]:
	F:=[seq(i,i=1..nops(FF))]:
	G:=[]:B:=[]:
	for i in F do
		F:=[op({op(F)} minus {i})]:
		G,B:=UPDATE(G,B,i):
		 #B:=sort(B,f2);
	od:
	rds:=0:
	B:=sort(B,f2);
	while nops(B)<>0 do
		p:=B[1]:
		B:=B[2..-1]:
		#w:=NormalForm(SPolynomial(Moshkel[p[1]][1],Moshkel[p[2]][1],t),[seq(Moshkel[G[i]][1],i=1..nops(G))],t):
		w:=MoraNF(SPolynomial(Moshkel[p[1]][1],Moshkel[p[2]][1],t),[seq(Moshkel[G[i]][1],i=1..nops(G))]):
		if w=0 then
			rds:=rds+1:
		else
			Moshkel:=[op(Moshkel),[w,LT(w,t)]]:
			G,B:=UPDATE(G,B,nops(Moshkel)):
			#B:=sort(B,f2);
		fi:
	od:
	H:=[seq(Moshkel[G[i]][1],i=1..nops(G))]:
	n:=kernelopts(bytesused,cputime):
	#print(IsGrobner(FF,H,t));
	# printf("%-1s %1s %1s %1s   : %3a\n",The,Grobner,Basis,is,H):
	# printf("%-1s %1s %1s%1s         : %3a %3a\n",The, cpu, time, is,[n-m][2],(sec)):
	# printf("%-1s %1s %1s        : %5a %3a\n",The,used,memory,[n-m][1],(bytes)):
	# printf("%-1s %1s %1s             : %5g\n",Num,of,Rds,rds):
	#printf("%-1s %1s %1s            : %2a\n",Num,of,poly,nops(G)):
	RETURN(H):
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
#   Normal Set
#####################
NSet := proc (LL) 
#option trace;
local g,L,V, N, v, x, m, i, j, u, flag, l; 
	L:={op(LM(LL))};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
NSett := proc (LL) 
#option trace;
local g,L,V, N, v, x, m, i, j, u, flag, l; 
	L:={op((LL))};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
#################################it has a rooted problem example in userguide
Normalset := proc (LL) 
#option trace;
local g,L,V, N, v, x, m, i, j, u, flag, l; 
#L:={op(LM(LL))};
L:={op([seq(LMGerm(f,12,[op(indets(LL))]),f=LL)])};
N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
################################
###   Multiplication Matrix
################################
MultMatrixFractional:=proc(S,u)
local L,n,M,i,v,j,c;
global t;
#option trace;
L:=NSet(LM(S));
n:=nops(L);
M:=Matrix(n);
for i from 1 to n do
	v:=MoraNF(u*L[i],S);#print(u,uuuu,v,L[i]);
	M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				M[j,i]:=c;
			fi;
		od;
od;
RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic1:=proc(L,vars)
#option trace;
local firsttime, firstbytes, II;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	II:=Itr1(L,vars);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------

Intrinsic2:=proc(F,V,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	Kazemi1:=Itr1(F,vars)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1(F,vars)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
	od;
	a := NULL;
	for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
	od;
		L := `minus`({op(W)}, {0});
		K := add(i, i = [a]);
		print("Intrinsic part is=",K);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

IntrinsicFractional:=proc(U,V,vars)
	if _params['U']<>NULL and _params['V']=NULL then
		Intrinsic1(U,vars)
	elif _params['U']<>NULL and _params['V']<>NULL then
		Intrinsic2(U,V,vars)
	fi;
end: 
       
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr1:=proc(Ideal,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
#F:=[g,lambda*diff(g,x),x*diff(g,x)];
	F:=Ideal;
	S:=STD(F,[vars[2],vars[1]],Ds);
	LMS:=LM(S); 
#flag:=false;
#for i from 1 to nops(S) while not flag do
#if indets(LMS[i])={x} then
#flag:=true;
#fi;
#od;
#if flag then
#for i from 1 to nops(S) while flag do
#if indets(LMS[i])={lambda} then
#flag:=false;
#fi;
#od;
#if flag then
#RETURN("The ideal is of infinite codimension.");
#fi;
#else
# RETURN("The ideal is of infinite codimension.");
#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {op(vars)} do         
		M:=MultMatrixFractional(S,u):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if MoraNF(m,S)<>0 then                    
				flag:=false;
			else         
#RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if MoraNF(m,S)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
	j:=1;
	ind:=MaxPower;
	while MM<>{} do
		MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
#OUT:=OUT,[i,j];
					B:=min(B,i);
#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];

	Y:=seq(MoraNF(F[i],L),i=1..nops(F));
	M:='M';
#L:=subs(y=lambda,L);
#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(MoraNF(F[i],L),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(op(vars))),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
#RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
#RETURN(OUT);  
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntDivAlg:=proc(f,FF,vars)
#option trace;
local p,r,n,T,i,flag,F;
	p:=f;
	r:=0;
	F:=subs(0=NULL,FF);
	n:=nops(F);
	T:=plex(op(vars));
	while p<>0 do
		 i:=1;
		 flag:=false;
		 while not flag and i<=n do 
			if LeadingMonomial(p,T)=LeadingMonomial(F[i],T) then
				 p:=simplify(p-F[i]/LeadingCoefficient(F[i],T)*LeadingCoefficient(p,T));
				 flag:=true;
			else
				 i:=i+1;
			fi;
		 od;
		 if not flag then
			r:=r+LeadingCoefficient(p,T)*LeadingMonomial(p,T);
			p:=simplify(p-LeadingCoefficient(p,T)*LeadingMonomial(p,T));
		fi;
	od;
	if r<>0 then
		 r:=r/LeadingCoefficient(r,T);
	fi;
	RETURN(r);    
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntDivAlgFormal:=proc(f,FF,k,vars)
#option trace;
local p,r,n,T,i,flag,F;
	p:=f;
	r:=0;
	F:=subs(0=NULL,FF);
	n:=nops(F);
	T:=plex(op(vars));
	while p<>0 do
		 i:=1;
		flag:=false;
		while not flag and i<=n do 
			 if LMFormal(p,vars,k)=LMFormal(F[i],vars,k) then
				 p:=simplify(p-F[i]/LeadingCoefficient(LTFormal(F[i],vars,k),T)*LeadingCoefficient(LTFormal(p,vars,k),T));
				flag:=true;
			else
				 i:=i+1;
			fi;
		od;
		if not flag then
			 r:=r+LeadingCoefficient(LTFormal(p,vars,k),T)*LMFormal(p,vars,k);
			p:=simplify(p-LeadingCoefficient(LTFormal(p,vars,k),T)*LMFormal(p,vars,k));
		fi;
	od;
	if r<>0 then
		 r:=r/LeadingCoefficient(LTFormal(r,vars,k),T);
	fi;
	RETURN(r);    
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

IntDivAlg1:=proc(f,FF,vars)
#option trace;
local p,r,n,T,i,flag,F;
	p:=f;
	r:=0;
	F:=subs(0=NULL,FF);
	n:=nops(F);
	T:=plex(op(vars));#(lambda,x)
	while p<>0 do
		 i:=1;
		 flag:=false;
		while not flag and i<=n do 
			 if LeadingMonomial(p,T)=LeadingMonomial(F[i],T) then
				 p:=simplify(p-F[i]/LeadingCoefficient(F[i],T)*LeadingCoefficient(p,T));
				 flag:=true;
			else
				 i:=i+1;
			fi;
		 od;
		if not flag then
			r:=r+LeadingCoefficient(p,T)*LeadingMonomial(p,T);
			p:=simplify(p-LeadingCoefficient(p,T)*LeadingMonomial(p,T));
		fi;
	od;
	if r<>0 then
		r:=r/LeadingCoefficient(r,T);
	fi;
	RETURN(r);    
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------

IntInterReduce:=proc(RR,vars)
local R,h,H,r;
#option trace;
	R:=subs(0=NULL,RR);
	H:=NULL;
	while nops(R)<>0 do
		r:=R[1];
		R:=R[2..-1];
		h:=IntDivAlg(r,[H,op(R)],vars);
		if h<>0 then
			H:=H,h;
		fi;
	od;
	RETURN([H]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntInterReduceFormal:=proc(RR,k,vars)
local R,h,H,r;
#option trace;
	R:=subs(0=NULL,RR);
	H:=NULL;
	while nops(R)<>0 do
		r:=R[1];
		R:=R[2..-1];
		h:=IntDivAlgFormal(r,[H,op(R)],k,vars);
		if h<>0 then
			H:=H,h;
		fi;
	od;
	RETURN([H]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
AlgObjectsFractional:=proc(ggg,vars)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0, vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognition(g,vars));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
############################New PRTT2
PRTT2:=proc(ggg,vars)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		 Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		 X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		 H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRTT2new:=proc(ggg,vars)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		 else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			 #print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		 l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0, vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		 RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg1(h,{op(RNF),H},[vars[2],vars[1]]);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
IG2:= proc (ff, V) 
#option trace;
local II,M,N,T,SortFun,S,NN,NNN,C,ZC,MaxPowerOfM,MinPowerOfMl,flag,q,L,i,MM,SB,ll;
	M:='M';
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		 N := N, T[nextvalue](); 
	end do; 

	SortFun:=proc(p,q)
		if p[1]=0 and q[1]<>0 then
			RETURN(false);
		fi;
		if p[1]=0 and q[1]=0 then
			RETURN(evalb(p[2]<q[2]));
		fi;
		if p[1]<>0 and q[1]=0 then
			 RETURN(true);
		fi;
		if p[1]<>0 and q[1]<>0 then
			 if p[2]=0 and q[2]<>0 then
				RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			 RETURN(evalb(p[1]<q[1]));
		fi;
		fi;
end:
	N:=sort([N],SortFun);
	S := 0;
	NN := 0;
	NNN := 0;
	C := NULL;
	ZC:=NULL;
	II:=NULL;
	MaxPowerOfM:=0;
	MinPowerOfMl:=infinity;
	flag:=false;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
			if q[-1] <> 0 then 
				if q[1]<>0 and (not flag or q[1]+q[-1]<MaxPowerOfM) then
					 NN := NN+M^q[1]*`<,>`(V[2]^q[-1]);
					 NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]); 
					MinPowerOfMl:=min(MinPowerOfMl,q[1]+q[-1]);
				elif q[1]=0 and (not flag or q[1]+q[-1]<MaxPowerOfM) and (q[-1]<MinPowerOfMl) then
					NN := NN+`<,>`(V[2]^q[-1]);
					NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]);                 
				fi;
			elif q[1]<>0 and not flag then
				NN := NN+M^q[1];
				NNN := NNN,V[1]^q[1];
				C:=C,Diff(f,V[1]$q[1]);
				MaxPowerOfM:=q[1]; 
				flag:=true;
			end if; 
			#NNN := NNN,x^q[1]*lambda^q[-1]; 
			#C := C, diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))<>0; 
			#L:=NULL;
			#for i from 1 to nops(V) do
			#    if q[i]<>0 then
			#        L:=L,seq(V[i],j=1..q[i]);
			#    fi;
			#od;
			#if L=NULL then
			#    C:=C,f<>0;
			#else
			#    C := C, Diff(f,subs(y=lambda,[L]))<>0; 
			 #fi;
			if q[1]<>0 then
				MM:=[MonomialMaker(q[1], V)];
				II:=II,op(expand(V[2]^q[-1]*MM));
			elif q[2]<>0 then
				II:=II, V[2]^q[-1];
			 fi;
		end if; 
	end do; 
	SB:=STD({II},V,Ds);   
	N:=NSet([op(LM(SB))]);
	ll:=1;
	if  1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,V[1]$degree(v,V[1]),V[2]$degree(v,V[2]))=0,v in N[ll..-1])];
	RETURN(NN, {NNN} minus {0}, C ,N); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################first code
with(PolynomialIdeals):
NF1:=proc(ggg,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H;
	t1:=kernelopts(cputime);
	g:=ggg;#subs(lambda=y,ggg);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(op(vars)));
	Sperp:={op(IG2(g,vars)[-1])}; 
	Pperp:={op(NSet(LM(STD(P0,vars,Ds))))};
	A:=Pperp minus Sperp;
	C:={op(IG2(g,vars)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		if LeadingMonomial(g,plex(op(vars)))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			od;
		od;
		d:=d-1;
    od;
    H:=seq(expand(subs(op(s),g)),s=[SS]);
    RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################second one
with(PolynomialIdeals):
NF2:=proc(ggg,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H;
	t1:=kernelopts(cputime);
	g:=ggg;#subs(lambda=y,ggg);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(op(vars)));
	Sperp:={op(IG2(g,vars)[-1])}; 
	Pperp:={op(NSet(LM(STD(P0,vars,Ds))))};
	A:=Pperp minus Sperp;
	C:={op(IG2(g,vars)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		 if LeadingMonomial(g,plex(op(vars)))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			 E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				fi;
			od;
		 od;
		if flag then
			d:=d-1;
		 fi;
	od;
	g:=expand(subs(ss,g));
	RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################option
NormalformFractional:=proc(ggg,vars,z)
	if  _params['ggg'] <> NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z'] = NULL then
		NF2(ggg,vars)
	elif  _params['ggg'] <> NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z'] = list then
		NF1(ggg,vars)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans1:=proc(G,VarsP,VarsN)
local a, J, K, B, H, Di;
#option trace;
	#a:={op(Vars)} minus {x,lambda};
	a:={op(VarsP)};
	#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
	# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
	# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	if G=(VarsN[1])^4-VarsN[2]*VarsN[1]+alpha[1]+alpha[2]*VarsN[2]+alpha[3]*(VarsN[1])^2 then 
		print("B=",{op(B)=0},"H=",{op(H)=0}, "D=",{op(Di)=0, alpha[3]<=0});
	elif G=(VarsN[1])^4+VarsN[2]+alpha[1]*VarsN[1]+alpha[2]*(VarsN[1])^2 then
		print("B=",{},"H=",{op(H)=0}, "D=",{op(Di)=0, alpha[2]<=0});
	elif G=(VarsN[1])^5-VarsN[2]+alpha[1]*VarsN[1]+alpha[2]*(VarsN[1])^2+alpha[3]*(VarsN[1])^3 then
		print("B=",{},"H=",{op(H)=0}, "D=",{op(Di)=0});
	elif G=(VarsN[1])^4+VarsN[2]*VarsN[1]+alpha[1]+alpha[2]*VarsN[2]+alpha[3]*(VarsN[1])^2 then
		print("B=",{op(B)=0},"H=",{op(H)=0}, "D=",{op(Di)=0, alpha[3]<=0});
	else
		print("B=",B,"H=",H, "D=",Di);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans2:=proc(G,LPar,VarsN)
local J, K, B, H, Di;
#option trace;
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,{op(LPar)});
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,{op(LPar)}));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,{op(LPar)})); 
	print("B=",B,"H=",H, "D=",Di);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans3:=proc(G,VarsP,VarsN)
local a, J, K, B, H, Di, P1, P2, P3;
	#a:={op(Vars)} minus {x,lambda};
	a:={op(VarsP)};
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	if nops(a)=2 then 
		P1:=implicitplot([op(B)],seq(a[i]=-0.5..0.5,i=1..nops(a)),color=blue,gridrefine=4);
    
		if nops(H)<>0 then
			P2:=implicitplot([op(H)],seq(a[i]=-0.5..0.5,i=1..nops(a)),color=green,gridrefine=4);
			if nops(Di)<>0 then
				P3:=implicitplot([op(Di)],seq(a[i]=-0.5..0.5,i=1..nops(a)),color=red,gridrefine=4);
				#P3:=implicitplot([op(Di)],alpha[1]=-0.5..0.5,alpha[2]=-0.5..0,color=red,gridrefine=4);
				RETURN(display(P1,P2,P3,thickness=4));
			fi;
				RETURN(display(P1,P2,thickness=4));
		fi;
		RETURN(display(P1,thickness=4));
		RETURN("B=",B,"H=",H,display(P1));
	elif nops(a)=3 then

		print(animate(implicitplot, [[op(B),op(H),op(Di)], a[1] = -9 .. 9, a[2] = -9 .. 9,color=[blue,green,red], thickness = 4,gridrefine=5], a[3] = -3 .. 3,frames=50));
		print(textplot([[0, 3, "B is Blue", font = [TIMES, ROMAN, 20], color = blue],[1, 3, "H is Green", font = [TIMES, ROMAN, 20], color = green],[2, 3, "D is Red", font = [TIMES, ROMAN, 20], color = red] ], axes = none));
	elif nops(a)=4 then
		print("dimension is more than three");
	fi;
end:
#<-----------------------------------------------------------------------------
Trans3repair:=proc(G,VarsP,VarsN)
local a, J, K, B, H, Di, P1, P2, P3;
	#a:={op(Vars)} minus {x,lambda};
	a:={op(VarsP)};
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);#print("B",B);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a)); #print("H",H);  
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx) >;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a));#print("D",Di);
	if nops(a)=2 then 
		P1:=implicitplot([op(B)],seq(a[i]=-1..1,i=1..nops(a)),color=green,gridrefine=4,legend=["B"]);
    
		if nops(H)<>0 then
			P2:=implicitplot([op(H)],seq(a[i]=-1..1,i=1..nops(a)),color="NavyBlue",gridrefine=4,legend=["H"]);
			if nops(Di)<>0 then
				P3:=implicitplot([op(Di)],seq(a[i]=-1..1,i=1..nops(a)),color=red,gridrefine=4);
				#P3:=implicitplot([op(Di)],alpha[1]=-0.7..0.7,alpha[2]=-1..0,color=red,gridrefine=4);
				RETURN(display(P1,P2,P3,thickness=2));
			fi;
				RETURN(display(P1,P2,thickness=2));
		fi;
		RETURN(display(P1,thickness=2));
		RETURN("B=",B,"H=",H,display(P1));
	elif nops(a)=3 then

		print(animate(implicitplot, [[op(B),op(H),op(Di)], a[1] = -9 .. 9, a[2] = -9 .. 9,color=[blue,green,red], thickness = 4,gridrefine=5], a[3] = -3 .. 3,frames=50));
		print(textplot([[0, 3, "B is Blue", font = [TIMES, ROMAN, 20], color = blue],[1, 3, "H is Green", font = [TIMES, ROMAN, 20], color = green],[2, 3, "D is Red", font = [TIMES, ROMAN, 20], color = red] ], axes = none));
	elif nops(a)=4 then
		print("dimension is more than three");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans4:=proc(G,l,VarsP,VarsN)
#option trace;
local a,b, J, K, B, H, Di, P1, P2, P3;
	#a:={op(Vars)} minus {x,lambda};
	a:={op(VarsP)};
	b:=a minus {l};
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	if nops(a)=2 then 
		P1:=implicitplot([op(B)],seq(a[i]=-2..2,i=1..nops(a)),color=blue,gridrefine=4);
    
		if nops(H)<>0 then
			P2:=implicitplot([op(H)],seq(a[i]=-2..2,i=1..nops(a)),color=green,gridrefine=4);
			if nops(Di)<>0 then
				P3:=implicitplot([op(Di)],seq(a[i]=-2..2,i=1..nops(a)),color=red,gridrefine=4);
				 #P3:=implicitplot([op(Di)],alpha[1]=-2..2,alpha[2]=-2..0,color=red,gridrefine=4);
				RETURN(display(P1,P2,P3,thickness=4));
			fi;
				RETURN(display(P1,P2,thickness=4));
		fi;
		RETURN(display(P1,thickness=4));
		RETURN("B=",B,"H=",H,display(P1));
	elif nops(a)=3 then

		print(animate(implicitplot, [[op(B),op(H),op(Di)], l[1] = -9 .. 9, l[2] = -9 .. 9,color=[blue,green,red], thickness = 4,gridrefine=5], l[3] = -3 .. 3,frames=50));
		print(textplot([[0, 3, "B is Blue", font = [TIMES, ROMAN, 20], color = blue],[1, 3, "H is Green", font = [TIMES, ROMAN, 20], color = green],[2, 3, "D is Red", font = [TIMES, ROMAN, 20], color = red] ], axes = none));
	elif nops(a)=4 then
		print("dimension is more than three");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######$#extra formula for truncation part##########################
Trans1Trunc:=proc(GG,VarsP,VarsN,k)
local a, J, K, B, H, Di,G;
#option trace;
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#a:=indets(G) minus {x,lambda};
	a:={op(VarsP)};
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	print("B=",B,"H=",H, "D=",Di);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans2Trunc:=proc(GG,L,VarsP,VarsN,k)
local J, K, B, H, Di,G;
#option trace;
#  Computing B
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,{op(L)});
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,{op(L)}));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,{op(L)})); 
	print("B=",B,"H=",H, "D=",Di);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans3Trunc:=proc(GG,VarsP,VarsN,k)
local a, J, K, B, H, Di, P1, P2, P3,G;
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#a:=indets(G) minus {x,lambda};
	a:={op(VarsP)};	
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	if nops(a)=2 then 
		P1:=implicitplot([op(B)],seq(a[i]=-2..2,i=1..nops(a)),color=blue,gridrefine=4);
    
		if nops(H)<>0 then
			P2:=implicitplot([op(H)],seq(a[i]=-2..2,i=1..nops(a)),color=green,gridrefine=4);
			if nops(Di)<>0 then
				P3:=implicitplot([op(Di)],seq(a[i]=-2..2,i=1..nops(a)),color=red,gridrefine=4);
				#P3:=implicitplot([op(Di)],alpha[1]=-2..2,alpha[2]=-2..0,color=red,gridrefine=4);
				RETURN(display(P1,P2,P3,thickness=4));
			fi;
			RETURN(display(P1,P2,thickness=4));
		fi;
		RETURN(display(P1,thickness=4));
		RETURN("B=",B,"H=",H,display(P1));
	elif nops(a)=3 then

		print(animate(implicitplot, [[op(B),op(H),op(Di)], a[1] = -9 .. 9, a[2] = -9 .. 9,color=[blue,green,red], thickness = 4,gridrefine=5], a[3] = -3 .. 3,frames=50));
		print(textplot([[0, 3, "B is Blue", font = [TIMES, ROMAN, 20], color = blue],[1, 3, "H is Green", font = [TIMES, ROMAN, 20], color = green],[2, 3, "D is Red", font = [TIMES, ROMAN, 20], color = red] ], axes = none));
		elif nops(a)=4 then
		print("dimension is more than three");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans4Trunc:=proc(GG,l,VarsP,VarsN,k)
#option trace;
local a,b, J, K, B, H, Di, P1, P2, P3,G;
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#a:=indets(G) minus {x,lambda};
	a:={op(VarsP)};
	b:=a minus {l};
#  Computing B
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,VarsN[1]),diff(G,VarsN[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,VarsN[1]), subs(VarsN[1]=xx,G), subs(VarsN[1]=xx,diff(G,VarsN[1])), 1-w*(VarsN[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a)); 
	if nops(a)=2 then 
		P1:=implicitplot([op(B)],seq(a[i]=-2..2,i=1..nops(a)),color=blue,gridrefine=4);
    
		if nops(H)<>0 then
			P2:=implicitplot([op(H)],seq(a[i]=-2..2,i=1..nops(a)),color=green,gridrefine=4);
			if nops(Di)<>0 then
				P3:=implicitplot([op(Di)],seq(a[i]=-2..2,i=1..nops(a)),color=red,gridrefine=4);
				 #P3:=implicitplot([op(Di)],alpha[1]=-2..2,alpha[2]=-2..0,color=red,gridrefine=4);
				RETURN(display(P1,P2,P3,thickness=4));
			fi;
			RETURN(display(P1,P2,thickness=4));
		fi;
		RETURN(display(P1,thickness=4));
		 RETURN("B=",B,"H=",H,display(P1));
	elif nops(a)=3 then

		print(animate(implicitplot, [[op(B),op(H),op(Di)], b[1] = -9 .. 9, b[2] = -9 .. 9,color=[blue,green,red], thickness = 4,gridrefine=5], l = -3 .. 3,frames=50));
		print(textplot([[0, 3, "B is Blue", font = [TIMES, ROMAN, 20], color = blue],[1, 3, "H is Green", font = [TIMES, ROMAN, 20], color = green],[2, 3, "D is Red", font = [TIMES, ROMAN, 20], color = red] ], axes = none));
	elif nops(a)=4 then
		print("dimension is more than three");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans_at_non_zero_point := proc(f, params, vars, k, point_in)
local g, g_taylor:

      g := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],f);
      g_taylor := mtaylor(g, [X,Y], k);
      return(Trans1(g_taylor, params, [X,Y]));
end proc:

Trans_at_non_zero_point_plot := proc(f, params, vars, k, point_in)
local g, g_taylor:

      g := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],f);
      g_taylor := mtaylor(g, [X,Y], k);
      return(Trans3(g_taylor, params, [X,Y]));
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Trans_at_non_zero_point_default := proc(f, params, vars, point_in)
local g, g_new, k, g_taylor:
       g := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],f);
       g_new := subs([seq(i=0,i=params)],g);
       k := Verifydefault1Special(g_new,[X,Y])+2;
       g_taylor := mtaylor(g, [X,Y], k);
       return(Trans1(g_taylor, params, [X,Y]));
end proc:

Trans_at_non_zero_point_default_plot := proc(f, params, vars, point_in)
local g, g_new, k, g_taylor:
       g := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],f);
       g_new := subs([seq(i=0,i=params)],g);
       k := Verifydefault1Special(g_new,[X,Y])+2;
       g_taylor := mtaylor(g, [X,Y], k);
       return(Trans3(g_taylor, params, [X,Y]));
end proc:

#Trans_at_non_zero_point_default_plot := proc(f, params, vars, point_in, Interval_in)

#end proc:
#>-----------------------------------------------------------------------------
TransitionSet:=proc(a,b,c,d,h,q)
	if _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] = NULL and _params['h'] = NULL and _params['q'] = NULL then
		Trans1(a,b,c)
elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and whattype(d)=integer and evalb(lhs(h)='SingularPoint') and _params['q'] = NULL then
              Trans_at_non_zero_point(a,b,c,d,rhs(h));
elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and whattype(d)=integer and evalb(lhs(h)='SingularPoint') and _params['q'] = plot then
              Trans_at_non_zero_point_plot(a,b,c,d,rhs(h));
elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and evalb(lhs(d)='SingularPoint') and _params['h'] = NULL and _params['q'] = NULL then
              Trans_at_non_zero_point_default(a,b,c,rhs(d));
elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and evalb(lhs(d)='SingularPoint') and _params['h'] = plot and _params['q'] = NULL then
              Trans_at_non_zero_point_default_plot(a,b,c,rhs(d));
	elif _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['h'] = NULL and _params['q'] = NULL then
		Trans1Trunc(a,b,c,d)
	elif _params['a']<>NULL and _params['b']<>NULL and type(b,list)=true and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and whattype(d)=list and _params['h'] = NULL and _params['q'] = NULL then
		Trans2(a,d,c)
	elif _params['a']<>NULL and _params['b']<>NULL and type(b,list)=true and _params['c'] <>NULL and whattype(c)=list and _params['d'] <>NULL and whattype(d)=integer and _params['h']<>NULL and whattype(h)=list and _params['q'] = NULL then 
		Trans2Trunc(a,h,b,c,d)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] =plot and _params['h'] = NULL and _params['q'] = NULL then
		 Trans3(a,b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and whattype(d)=integer and _params['h'] = plot and _params['q'] = NULL then
		 Trans3Trunc(a,b,c,d)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL  and _params['h'] = plot and _params['q'] = NULL then
		Trans4(a,d,b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=list and _params['d'] <> NULL and whattype(d)=integer and _params['h']<>NULL and _params['q'] = plot then
		Trans4Trunc(a,h,b,c,d)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagramnew:=proc(G,VarsP,VarsN)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ;
#with(plots,implicitplot):
	#ET:={op(Vars)} minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		 ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		with(plots,implicitplot):
		 with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]<0)):#title= "negative case"  
		BQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]=0)):    
		CQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagramnewSpecial:=proc(GG,VarsP,VarsN,k)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		 ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		 animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		 # print("please enter gamma");
		with(plots,implicitplot):
		with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]<0)):  
		BQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]=0)):    
		CQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),ET[3]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		 print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PersistentPathnew:=proc(G,f,h,VarsP,VarsN)
local ET,ABC1,CBA,QA,QB,QC;
#with(plots,implicitplot):
	#ET:={op(vars)} minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		 ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		 # print("please enter gamma");
		 with(plots,implicitplot):
		with(plots):
		CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		QA:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]<0)):  
		QB:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]=0)):
		QC:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentPathnewSpecial:=proc(GG,f,h,VarsP,VarsN,k)
local ET,ABC1,CBA,QA,QB,QC,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		with(plots,implicitplot):
		 with(plots):
		CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		QA:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]<0)):  
		QB:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]=0)):
		QC:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[2]=h(\zeta),ET[3]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[3]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################universal unfolding
UniversalUnfolding1:=proc(g,vars)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET:=PRTT2(g,vars);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformFractional(g,vars)+add(alpha[i]*ET[i],i=1..nops(ET));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding2:=proc(g,vars)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET1:=PRTT2(g,vars);
	ET2:=PRTT2new(g,vars);
	G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
	G3:=NormalformFractional(g,vars)+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G4:=NormalformFractional(g,vars)+add(alpha[i]*ET2[i],i=1..nops(ET2));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([[G1,G2],[G3,G4]]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------

UniversalUnfoldingFractional:=proc(a,b,c,vars)
	if _params['b'] = NULL and _params['c'] = NULL and _params['vars'] <> NULL  then
		UniversalUnfolding1(a)[1]
	elif _params['b'] = list and _params['c'] = NULL  and _params['vars'] <> NULL  then
		 UniversalUnfolding2(a)[1]
	elif _params['b'] = normalform and _params['c'] = NULL  and _params['vars'] <> NULL  then 
		UniversalUnfolding1(a)[2]
	elif _params['b'] = normalform and _params['c'] = list  and _params['vars'] <> NULL  then  
		UniversalUnfolding2(a)[2]
	fi;  
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagram2new:=proc(G,VarsP,VarsN)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ;
#with(plots,implicitplot):
	#ET:={op(Vars)} minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		 ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		with(plots,implicitplot):
		with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]<0)):  
		BQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]=0)):    
		CQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagram2newSpecial:=proc(GG,VarsP,VarsN,k)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		 ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		 # print("please enter gamma");
		with(plots,implicitplot):
		 with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]<0)):  
		BQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]=0)):    
		CQ:=animate(implicitplot,[subs(ET[1]=sin(\zeta),ET[3]=cos(\zeta),ET[2]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagram1new:=proc(G,VarsP,VarsN)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ;
#with(plots,implicitplot):
	#ET:={op(G)} minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		with(plots,implicitplot):
		 with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]<0)):  
		BQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]=0)):    
		CQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PersistentDiagram1newSpecial:=proc(GG,VarsP,VarsN,k)
#option trace;
local ET,ABC1,ABC,AQ,BQ,CQ,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=sin(\zeta),ET[2]=cos(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		 # print("please enter gamma");
		 with(plots,implicitplot):
		with(plots):
		ABC:=Array(1..1,1..3,[[AQ,BQ,CQ]]);
		AQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]<0)):  
		BQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]=0)):    
		 CQ:=animate(implicitplot,[subs(ET[2]=sin(\zeta),ET[3]=cos(\zeta),ET[1]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]>0)):
		display(Array(1..1,1..3,[[AQ,BQ,CQ]])):  
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
PersistentPath2new:=proc(G,f,h,VarsP,VarsN)
local ET,ABC1,CBA,QA,QB,QC;
#with(plots,implicitplot):
	#ET:={op(Vars)} minus {x,lambda};
	ET:=VarsP; 
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		with(plots,implicitplot):
		with(plots):
		 CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		QA:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]<0)):  
		QB:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]=0)):
		QC:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentPath2newSpecial:=proc(GG,f,h,VarsP,VarsN,k)
local ET,ABC1,CBA,QA,QB,QC,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP; 
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		 with(plots,implicitplot):
		with(plots):
		CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		QA:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]<0)):  
		QB:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]=0)):
		QC:=animate(implicitplot,[subs(ET[1]=f(\zeta),ET[3]=h(\zeta),ET[2]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[2]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentPath1new:=proc(G,f,h,VarsP,VarsN)
local ET,ABC1,CBA,QA,QB,QC;
#with(plots,implicitplot):
	ET:=VarsP;
	#ET:={op(Vars)} minus {x,lambda};
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		# print("please enter gamma");
		 with(plots,implicitplot):
		with(plots):
		 CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		QA:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]<0)):  
		QB:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]=0)):
		QC:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentPath1newSpecial:=proc(GG,f,h,VarsP,VarsN,k)
local ET,ABC1,CBA,QA,QB,QC,G;
#with(plots,implicitplot):
	G:=mtaylor(GG,[op(VarsP),op(VarsN)],k+1);
	#ET:=indets(G) minus {x,lambda};
	ET:=VarsP;
	if nops(ET)=2 then
		ABC1:=subs(ET[1]=f(\zeta),ET[2]=h(\zeta),G);
		animate(implicitplot,[ABC1,VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=-1..1,scaling=constrained);
	elif nops(ET)=1 then
		animate(implicitplot,[G,VarsN[1]=-3..3,VarsN[2]=-3..3],ET[1]=-1..1,scaling=constrained);
	elif nops(ET)=3 then
		 # print("please enter gamma");
		with(plots,implicitplot):
		with(plots):
		 CBA:=Array(1..1,1..3,[[QA,QB,QC]]);
		 QA:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=-2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]<0)):  
		QB:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=0,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]=0)):
		QC:=animate(implicitplot,[subs(ET[2]=f(\zeta),ET[3]=h(\zeta),ET[1]=2,G),VarsN[1]=-3..3,VarsN[2]=-3..3],\zeta=0..2*Pi,scaling=constrained,caption= typeset(ET[1]>0)):
		display(Array(1..1,1..3,[[QA,QB,QC]])):   
	else
		print("It is 4-dim");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Persistent_Simple_default := proc(poly_in, vars_in)
	return(implicitplot(poly_in, vars_in[2]=-0.7..0.7, vars_in[1]=-0.7..0.7, gridrefine=3));
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Persistent_Simple_interval_option := proc(poly_in, vars_in, interval_in)
	return(implicitplot(poly_in, vars_in[2]=interval_in[2], vars_in[1]=interval_in[1], gridrefine=3));
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Persistent_Diagram_interval := proc(par_germ_in, params_in, vars_in, values_in, interval_in)
	return(implicitplot(subs([params_in[1]=values_in[1], params_in[2]=values_in[2]],par_germ_in), vars_in[2]=interval_in[2], vars_in[1]=interval_in[1], gridrefine=3));
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PersistentDiagram:=proc(AB,f,g,h,q,p,w)
#option trace;
	if _params['AB']<>NULL and _params['f'] <> NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=list and _params['h'] <> NULL and lhs(h)='values' and _params['q'] <> NULL and lhs(q)='IntervalPlot' and _params['p'] = NULL  and _params['w']=NULL then
		Persistent_Diagram_interval(AB, f, g, [rhs(rhs(h)[1]), rhs(rhs(h)[2])], [rhs(rhs(q)[1]),rhs(rhs(q)[2])])
	elif _params['AB']<>NULL and _params['f'] <> NULL and whattype(f)=list and _params['g']=NULL and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL  and _params['w']=NULL then
		Persistent_Simple_default(AB,f)
	elif _params['AB']<>NULL and _params['f'] <> NULL and whattype(f)=list and _params['g']<>NULL and lhs(g)='IntervalPlot' and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL  and _params['w']=NULL then
		Persistent_Simple_interval_option(AB, f, rhs(g));
	elif _params['AB']<>NULL and _params['f'] <> NULL and whattype(f)=list and _params['g']<> NULL and whattype(g)=list and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL  and _params['w']=NULL then 
		PersistentDiagramnew(AB,f,g)
	 elif _params['AB']<>NULL and _params['f'] <> NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=list and _params['h']<> NULL and whattype(h)=integer and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then 
		PersistentDiagramnewSpecial(AB,f,g,h)
    
	elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] <> NULL and whattype(g)=list and _params['h'] =f[1]  and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then     
		PersistentDiagram1new(AB,f,g)
	elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] <> NULL and whattype(g)=list and _params['h'] <> NULL and whattype(h)=integer and _params['q'] = f[1] and _params['p'] = NULL and _params['w']=NULL then     
		PersistentDiagram1newSpecial(AB,f,g,h) 
     
	 elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=list and _params['h'] = f[2]  and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then 
		PersistentDiagram2new(AB,f,g)
     
	elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] <> NULL  and whattype(g)=list and _params['h'] <> NULL and whattype(h)=integer and _params['q'] = f[2] and _params['p'] = NULL and _params['w']=NULL then 
		PersistentDiagram2newSpecial(AB,f,g,h)
     
	elif _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL and _params['h']<>NULL and whattype(h)=list and _params['q'] <> NULL and whattype(q)=list and _params['p'] = h[1] and _params['w']=NULL then
		PersistentPath1new(AB,f,g,h,q)
	elif _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL and _params['h']<>NULL and whattype(h)=list and _params['q'] <> NULL and whattype(q)=list and _params['p'] <> NULL and whattype(p)=integer and _params['w'] = h[1]  then
		PersistentPath1newSpecial(AB,f,g,h,q,p)  
      
	elif  _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL and _params['h']<>NULL and whattype(h)=list and _params['q'] <> NULL and whattype(q)=list and _params['p']=h[2] and _params['w']=NULL then
		 PersistentPath2new(AB,f,g,h,q)
      
	elif  _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL and _params['h']<>NULL and whattype(h)=list and _params['q'] <> NULL and whattype(q)=list and _params['p']<>NULL and whattype(p)=integer and _params['w']=h[2] then
		PersistentPath2newSpecial(AB,f,g,h,q,p)
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] = plot and _params['h']=ShortList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		Shortplot(AB,f)
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=integer and _params['h']=plot and _params['q']=ShortList and _params['p'] = NULL and _params['w']=NULL then
		ShortplotSpecial(AB,f,g) 
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']=ShortList and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		Short(AB,f)
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] <> NULL and whattype(g)=integer and _params['h']=ShortList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		ShortSpecial(AB,f,g)   
	 elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] = plot and _params['h']=IntermediateList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		Intermediateplot(AB,f)
        
         elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=integer and _params['h']=plot and _params['q']=IntermediateList and _params['p'] = NULL and _params['w']=NULL then
		IntermediateplotSpecial(AB,f,g)
        
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']=IntermediateList and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		Intermediate(AB,f)
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] <>NULL and whattype(g)=integer and _params['h']=IntermediateList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then
		IntermediateSpecial(AB,f,g)    
        
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g'] =plot and _params['h']=CompleteList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then 
		Completeplot(AB,f)
	elif  _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=integer and _params['h']=plot and _params['q']=CompleteList and _params['p'] = NULL and _params['w']=NULL then 
		CompleteplotSpecial(AB,f,g)    
        
	elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']=CompleteList and _params['h'] = NULL and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then 
		Complete(AB,f) 
	elif _params['AB']<>NULL and _params['f']<>NULL and whattype(f)=list and _params['g']<>NULL and whattype(g)=integer and _params['h']=CompleteList and _params['q'] = NULL and _params['p'] = NULL and _params['w']=NULL then 
		CompleteSpecial(AB,f,g)  
	elif  _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL and _params['h'] <> NULL and whattype(h)=list and _params['q']<>NULL and whattype(q)=list and _params['p'] = NULL and _params['w']=NULL then 
		PersistentPathnew(AB,f,g,h,q)
      
	elif  _params['AB']<>NULL and _params['f']<>NULL and _params['g']<>NULL  and _params['h'] <> NULL and whattype(h)=list and _params['q'] <> NULL and whattype(q)=list and _params['p']<> NULL and whattype(p)=integer and _params['w']=NULL then 
		PersistentPathnewSpecial(AB,f,g,h,q,p)
	else
		 print("Error");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#####################################################source of nonpersistent case two
NonPersistentSource:=proc(f,VarsP,VarsN,X,Y)
#option trace;
local N,i,j,S,U,k,V,W,Z,ZZ,WW,BB,HH,DI,E1,E2,E3,E4,E5,E6,E7,E8,E9,IND;
with(PolynomialIdeals):
	#IND:=indets(f) minus {x,lambda};
	IND:={op(VarsP)};
	N:=NULL;
	for i in {op(X)} do
		for j in {op(Y)} do
			N:=N,[i,j];
		od;
	od;
	S:=[N];
	U:=NULL;
	for k from 1 to nops(S) do
		U:=U,op(IdealInfo:-Generators(EliminationIdeal(<f,VarsN[1]-S[k][1],VarsN[2]-S[k][2]>,IND)));
	od;
	V:=NULL;
	W:=NULL;
	Z:=NULL;
	ZZ:=NULL;
	for i from 1 to 2 do
		V:=V,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[1]-X[i]>,IND)));
		W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[2]-Y[i]>,IND)));
		Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[2]),VarsN[1]-X[i]>,IND)));
		ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),subs(VarsN[1]=X[i],f),1-zeta*(VarsN[1]-X[i])>,IND)));
	od;
	#W:=NULL;
	#for i from 1 to 2 do
	#W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,x),lambda-Y[i]>,indets(f)minus{x,lambda})));
	#od;
	#Z:=NULL;
	#for i from 1 to 2 do
	#Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,lambda),x-X[i]>,indets(f)minus{x,lambda})));
	#od;
	#ZZ:=NULL;
	#for i from 1 to 2 do
	#ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,x),subs(x=X[i],f),1-zeta*(x-X[i])>,indets(f)minus{x,lambda})));
	#od;
	WW:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=X[1],f),subs(VarsN[1]=X[2],f),1-zeta*(X[1]-X[2])>,IND)));
	BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND)));
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND)));#$#hi
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND)));
	print("Lc=",[U],"Lsh=",[V], "Lsv=",[W],"Lt=",[Z],"g1=",[ZZ],"g2=",[WW],"B=",[BB],"H=",[HH],"D=",[DI] );
	with(plots):
	with(plots,implicitplot):
	E1:=NULL;
	#tedad:={seq(op(indets(i)),i=[U,V,W,Z,ZZ,WW,BB,HH,DI])};
	for i from 1 to nops([U]) do
		if nops(indets([U][i]))=1 then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#if nops(indets([U][i]))=1 and indets([U][i])={alpha} then
			# E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			# elif nops(indets([U][i]))=1 and indets([U][i])={beta} then
			# E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			# elif nops(indets([U][i]))=1 and indets([U][i])={mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([U][i]))=2 then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([U][i]))=2 and indets([U][i])={alpha,beta} then
			# E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			# elif nops(indets([U][i]))=2 and indets([U][i])={alpha,mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([U][i]))=2 and indets([U][i])={beta,mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([U][i]))=3 then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E2:=NULL;
	for i from 1 to nops([V]) do
		if nops(indets([V][i]))=1 then #and indets([V][i])={alpha} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={beta} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=2 then #and indets([V][i])={alpha,beta} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={alpha,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={beta,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=3 then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E3:=NULL;
	for i from 1 to nops([W]) do
		if nops(indets([W][i]))=1 then #and indets([W][i])={alpha} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={beta} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=2 then #and indets([W][i])={alpha,beta} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([W][i]))=2 and indets([W][i])={alpha,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=2 and indets([W][i])={beta,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=3 then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E4:=NULL;
	for i from 1 to nops([Z]) do
		if nops(indets([Z][i]))=1 then #and indets([Z][i])={alpha} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={beta} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=2 then #and indets([Z][i])={alpha,beta} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={alpha,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={beta,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=3 then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E5:=NULL;
	for i from 1 to nops([ZZ]) do
		if nops(indets([ZZ][i]))=1 then #and indets([ZZ][i])={alpha} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={beta} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=2 then #and indets([ZZ][i])={alpha,beta} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={alpha,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={beta,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=3 then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E6:=NULL;
	for i from 1 to nops([WW]) do
		if nops(indets([WW][i]))=1 then #and indets([WW][i])={alpha} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={beta} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=2 then #and indets([WW][i])={alpha,beta} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={alpha,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={beta,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=3 then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
		#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		#elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1 then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1 then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E1,E2,E3,E4,E5,E6,E7,E8,E9]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
  ########################################################################Nonpersistent option in intervals
NonPersistentSource2:=proc(f,VarsP,VarsN,X,Y,A,B)
#option trace;
local N,i,j,S,U,k,V,W,Z,ZZ,WW,BB,HH,DI,E1,E2,E3,E4,E5,E6,E7,E8,E9,IND;
	with(PolynomialIdeals):
	#IND:=indets(f) minus {x,lambda};
	IND:={op(VarsP)};
	N:=NULL;
	for i in {op(X)} do
		for j in {op(Y)} do
			N:=N,[i,j];
		od;
	od;
	S:=[N];
	U:=NULL;
	for k from 1 to nops(S) do
		U:=U,op(IdealInfo:-Generators(EliminationIdeal(<f,VarsN[1]-S[k][1],VarsN[2]-S[k][2]>,IND)));
	od;
	V:=NULL;
	W:=NULL;
	Z:=NULL;
	ZZ:=NULL;
	for i from 1 to 2 do
		V:=V,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[1]-X[i]>,IND)));
		W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[2]-Y[i]>,IND)));
		Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[2]),VarsN[1]-X[i]>,IND)));
		ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),subs(VarsN[1]=X[i],f),1-zeta*(VarsN[1]-X[i])>,IND)));
       od;
	#W:=NULL;
	#for i from 1 to 2 do
	#W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,x),lambda-Y[i]>,indets(f)minus{x,lambda})));
	#od;
	#Z:=NULL;
	#for i from 1 to 2 do
	 #Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,lambda),x-X[i]>,indets(f)minus{x,lambda})));
	 #od;
	 #ZZ:=NULL;
	 #for i from 1 to 2 do
	 #ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,x),subs(x=X[i],f),1-zeta*(x-X[i])>,indets(f)minus{x,lambda})));
	 #od;
	WW:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=X[1],f),subs(VarsN[1]=X[2],f),1-zeta*(X[1]-X[2])>,IND)));
	BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND)));
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND)));
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND)));
	print("Lc=",[U],"Lsh=",[V], "Lsv=",[W],"Lt=",[Z],"g1=",[ZZ],"g2=",[WW],"B=",[BB],"H=",[HH],"D=",[DI] );
	with(plots):
	with(plots,implicitplot):
	E1:=NULL;
	for i from 1 to nops([U]) do
		if nops(indets([U][i]))=1 then #and indets([U][i])={alpha} then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=A[1]..A[2],ind[2]=B[1]..B[2],gridrefine=5],ind[3]=-1..1);
			#elif nops(indets([U][i]))=1 and indets([U][i])={beta} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([U][i]))=1 and indets([U][i])={mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([U][i]))=2 then #and indets([U][i])={alpha,beta} then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([U][i]))=2 and indets([U][i])={alpha,mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([U][i]))=2 and indets([U][i])={beta,mm} then
			#E1:=E1,animate(implicitplot,[[U][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([U][i]))=3 then
			E1:=E1,animate(implicitplot,[[U][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E2:=NULL;
	for i from 1 to nops([V]) do
		if nops(indets([V][i]))=1 then #and indets([V][i])={alpha} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={beta} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=2 then #and indets([V][i])={alpha,beta} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={alpha,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={beta,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=3 then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	 E3:=NULL;
	for i from 1 to nops([W]) do
		if nops(indets([W][i]))=1 then #and indets([W][i])={alpha} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],ind[2]=B[1]..B[2],gridrefine=5],ind[3]=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={beta} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=2 then #and indets([W][i])={alpha,beta} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		#elif nops(indets([W][i]))=2 and indets([W][i])={alpha,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		#elif nops(indets([W][i]))=2 and indets([W][i])={beta,mm} then
			 #E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=3 then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E4:=NULL;
	for i from 1 to nops([Z]) do
		if nops(indets([Z][i]))=1 then #and indets([Z][i])={alpha} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={beta} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=2 then #and indets([Z][i])={alpha,beta} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={alpha,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={beta,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=3 then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E5:=NULL;
	for i from 1 to nops([ZZ]) do
		if nops(indets([ZZ][i]))=1 then #and indets([ZZ][i])={alpha} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={beta} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=2 then #and indets([ZZ][i])={alpha,beta} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={alpha,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={beta,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=3 then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E6:=NULL;
	for i from 1 to nops([WW]) do
		if nops(indets([WW][i]))=1 then #and indets([WW][i])={alpha} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={beta} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=2 then #and indets([WW][i])={alpha,beta} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={alpha,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={beta,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=3 then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			 E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1 then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);;
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		 elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E1,E2,E3,E4,E5,E6,E7,E8,E9]);
   end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#########################F has no zero on bound(U)L 
 NonPersistentBound:=proc(f,VarsP,VarsN,X,Y)
 #option trace;
 local W,i,BB,HH,DI,E3,E7,E8,E9,IND;
	with(PolynomialIdeals);
	 #IND:=indets(f) minus {x,lambda};
	IND:={op(Varsp)};
	W:=NULL;
	for i from 1 to 2 do
		W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[2]-Y[i]>,IND))):
	od:
	BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND))):
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND))):
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND))):
	print("Lsv=",[W],"B=",[BB],"H=",[HH],"D=",[DI] ):
	with(plots):
	with(plots,implicitplot):
	E3:=NULL;
	for i from 1 to nops([W]) do
		if nops(indets([W][i]))=1 then #and indets([W][i])={alpha} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={beta} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=2 then #and indets([W][i])={alpha,beta} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([W][i]))=2 and indets([W][i])={alpha,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=2 and indets([W][i])={beta,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=3 then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	 od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1 then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1 then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
		 #elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E3,E7,E8,E9]);
 end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################obtion for interval 
 NonPersistentBound1:=proc(f,VarsP,VarsN,X,Y,A,B)
 #option trace;
 local W,i,BB,HH,DI,E3,E7,E8,E9,IND;
	with(PolynomialIdeals);
	#IND:=indets(f) minus {x,lambda};
	IND:={op(VarsP)};
	W:=NULL;
	for i from 1 to 2 do
		W:=W,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[2]-Y[i]>,IND))):
	od:
	BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND))):
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND))):
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND))):
	print("Lsv=",[W],"B=",[BB],"H=",[HH],"D=",[DI] ):
	with(plots):
	with(plots,implicitplot):
	E3:=NULL;
	for i from 1 to nops([W]) do
		if nops(indets([W][i]))=1 then #and indets([W][i])={alpha} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={beta} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=1 and indets([W][i])={mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=2 then #and indets([W][i])={alpha,beta} then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		#elif nops(indets([W][i]))=2 and indets([W][i])={alpha,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([W][i]))=2 and indets([W][i])={beta,mm} then
			#E3:=E3,animate(implicitplot,[[W][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([W][i]))=3 then
			E3:=E3,animate(implicitplot,[[W][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			 #E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			 #E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1 then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			 #elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1 then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E3,E7,E8,E9]);
 end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################F does not vanish on UboundL
NonPersistentbound:=proc(f,VarsP,VarsN,X,Y)
#option trace;
local V,Z,ZZ,i,WW,BB,HH,DI,E2,E4,E5,E6,E7,E8,E9,IND;
	with(PolynomialIdeals):
	#IND:=indets(f) minus {x,lambda};
	IND:={op(VarsP)};
	V:=NULL;
	Z:=NULL;
	ZZ:=NULL;
	for i from 1 to 2 do
		V:=V,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[1]-X[i]>,IND)));
		Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[2]),VarsN[1]-X[i]>,IND)));
		ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),subs(VarsN[1]=X[i],f),1-zeta*(VarsN[1]-X[i])>,IND)));
	od;
	WW:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=X[1],f),subs(VarsN[1]=X[2],f),1-zeta*(X[1]-X[2])>,IND)));
	 BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND)));
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND)));
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND)));
	print("Lsh=",[V],"Lt=",[Z],"g1=",[ZZ],"g2=",[WW],"B=",[BB],"H=",[HH],"D=",[DI] );
	with(plots):
	with(plots,implicitplot):
	E2:=NULL;
	for i from 1 to nops([V]) do
		if nops(indets([V][i]))=1 then #and indets([V][i])={alpha} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={beta} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=2 then #and indets([V][i])={alpha,beta} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={alpha,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={beta,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=3 then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E4:=NULL;
	for i from 1 to nops([Z]) do
		if nops(indets([Z][i]))=1 then #and indets([Z][i])={alpha} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={beta} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=2 then #and indets([Z][i])={alpha,beta} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={alpha,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={beta,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=3 then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E5:=NULL;
	for i from 1 to nops([ZZ]) do
		if nops(indets([ZZ][i]))=1 then #and indets([ZZ][i])={alpha} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={beta} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=2 then #and indets([ZZ][i])={alpha,beta} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={alpha,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={beta,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=3 then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E6:=NULL;
	for i from 1 to nops([WW]) do
		if nops(indets([WW][i]))=1 then #and indets([WW][i])={alpha} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={beta} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=2  then #and indets([WW][i])={alpha,beta} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={alpha,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={beta,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=-1..1,beta=-1..1,gridrefine=5],mm=-1..1);
		 elif nops(indets([WW][i]))=3 then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
			 #elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	 od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1 then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=-1..1,beta=-1..1,gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1 then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=-1..1,beta=-1..1,gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=-1..1,IND[2]=-1..1,gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E2,E4,E5,E6,E7,E8,E9]);
   end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################Option for intervals 
NonPersistentbound1:=proc(f,VarsP,VarsN,X,Y,A,B)
#option trace;
local V,Z,ZZ,i,WW,BB,HH,DI,E2,E4,E5,E6,E7,E8,E9,IND;
with(PolynomialIdeals):
	#IND:=indets(f) minus {x,lambda};
	IND:={op(VarsP)};
	V:=NULL;
	Z:=NULL;
	ZZ:=NULL;
	for i from 1 to 2 do
		V:=V,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),VarsN[1]-X[i]>,VarsP)));
		Z:=Z,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[2]),VarsN[1]-X[i]>,VarsP)));
		ZZ:=ZZ,op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),subs(VarsN[1]=X[i],f),1-zeta*(VarsN[1]-X[i])>,IND)));
	od;
	WW:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=X[1],f),subs(VarsN[1]=X[2],f),1-zeta*(X[1]-X[2])>,IND)));
	BB:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,VarsN[2])>,IND)));
	HH:=op(IdealInfo:-Generators(EliminationIdeal(<f,diff(f,VarsN[1]),diff(f,[VarsN[1]$2])>,IND)));
	DI:=op(IdealInfo:-Generators(EliminationIdeal(<subs(VarsN[1]=x1,f),subs(VarsN[1]=x1,diff(f,VarsN[1])),subs(VarsN[1]=x2,f),subs(VarsN[1]=x2,diff(f,VarsN[1])),1-zeta*(x1-x2)>,IND)));
	print("Lsh=",[V],"Lt=",[Z],"g1=",[ZZ],"g2=",[WW],"B=",[BB],"H=",[HH],"D=",[DI] );
	with(plots):
	with(plots,implicitplot):
	E2:=NULL;
	for i from 1 to nops([V]) do
		if nops(indets([V][i]))=1 then #and indets([V][i])={alpha} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			 #elif nops(indets([V][i]))=1 and indets([V][i])={beta} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=1 and indets([V][i])={mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=2 then #and indets([V][i])={alpha,beta} then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={alpha,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([V][i]))=2 and indets([V][i])={beta,mm} then
			#E2:=E2,animate(implicitplot,[[V][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([V][i]))=3 then
			E2:=E2,animate(implicitplot,[[V][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E4:=NULL;
	for i from 1 to nops([Z]) do
		if nops(indets([Z][i]))=1 then #and indets([Z][i])={alpha} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={beta} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=1 and indets([Z][i])={mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		 elif nops(indets([Z][i]))=2 then #and indets([Z][i])={alpha,beta} then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={alpha,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([Z][i]))=2 and indets([Z][i])={beta,mm} then
			#E4:=E4,animate(implicitplot,[[Z][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([Z][i]))=3 then
			E4:=E4,animate(implicitplot,[[Z][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E5:=NULL;
	for i from 1 to nops([ZZ]) do
		if nops(indets([ZZ][i]))=1 then #and indets([ZZ][i])={alpha} then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={beta} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=1 and indets([ZZ][i])={mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([ZZ][i]))=2 then #and indets([ZZ][i])={alpha,beta} then
			 E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={alpha,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([ZZ][i]))=2 and indets([ZZ][i])={beta,mm} then
			#E5:=E5,animate(implicitplot,[[ZZ][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		 elif nops(indets([ZZ][i]))=3 then
			E5:=E5,animate(implicitplot,[[ZZ][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E6:=NULL;
	for i from 1 to nops([WW]) do
		if nops(indets([WW][i]))=1 then #and indets([WW][i])={alpha} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={beta} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=1 and indets([WW][i])={mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=2 then #and indets([WW][i])={alpha,beta} then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={alpha,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
			#elif nops(indets([WW][i]))=2 and indets([WW][i])={beta,mm} then
			#E6:=E6,animate(implicitplot,[[WW][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5],mm=-1..1);
		elif nops(indets([WW][i]))=3 then
			E6:=E6,animate(implicitplot,[[WW][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5],IND[3]=-1..1);
		fi;
	od;
	E7:=NULL;
	for i from 1 to nops([BB]) do
		if nops(indets([BB][i]))=1 then #and indets([BB][i])={alpha} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={beta} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=1 and indets([BB][i])={mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=2 then #and indets([BB][i])={alpha,beta} then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={alpha,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
			#elif nops(indets([BB][i]))=2 and indets([BB][i])={beta,mm} then
			#E7:=E7,animate(implicitplot,[[BB][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=blue],mm=-1..1);
		elif nops(indets([BB][i]))=3 then
			E7:=E7,animate(implicitplot,[[BB][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=blue],IND[3]=-1..1);
		fi;
	od;
	E8:=NULL;
	for i from 1 to nops([HH]) do
		if nops(indets([HH][i]))=1  then #and indets([HH][i])={alpha} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={beta} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=1 and indets([HH][i])={mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=2 then #and indets([HH][i])={alpha,beta} then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={alpha,mm} then
			#E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
			#elif nops(indets([HH][i]))=2 and indets([HH][i])={beta,mm} then
			 #E8:=E8,animate(implicitplot,[[HH][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color="HotPink"],mm=-1..1);
		elif nops(indets([HH][i]))=3 then
			E8:=E8,animate(implicitplot,[[HH][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color="HotPink"],IND[3]=-1..1);
		fi;
	od;
	E9:=NULL;
	for i from 1 to nops([DI]) do
		if nops(indets([DI][i]))=1 then #and indets([DI][i])={alpha} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={beta} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=1 and indets([DI][i])={mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=2 then #and indets([DI][i])={alpha,beta} then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={alpha,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
			#elif nops(indets([DI][i]))=2 and indets([DI][i])={beta,mm} then
			#E9:=E9,animate(implicitplot,[[DI][i],alpha=A[1]..A[2],beta=B[1]..B[2],gridrefine=5,color=yellow],mm=-1..1);
		elif nops(indets([DI][i]))=3 then
			E9:=E9,animate(implicitplot,[[DI][i],IND[1]=A[1]..A[2],IND[2]=B[1]..B[2],gridrefine=5,color=yellow],IND[3]=-1..1);
		fi;
	od;
	display([E2,E4,E5,E6,E7,E8,E9]);
   end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################SNF
SNF:=proc(f,F,V,vars)
local r;
	r:=NormalForm(f,F,plex(op(vars)));
	r:=IntDivAlg(r,V,vars);
	return(r);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
########################################Nset
Nset := proc (LL) 
#option trace;
local g,L,V, d, N, v, x, m, i, j, u, flag, l; 
	#L:={op(LM(LL))};
	L:=LL;
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

MonomTotal:=proc(F,vars)
local B,f,A,g,C;
	B := NULL;
	for f in F do
		A := [MonomialMaker(f[1], vars)];
		for g in A do
			B := B, g*vars[2]^f[2];
		od;
	od;
	C := {B};
	return [op(C)];
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------

################################MINIMAL1/I should bring their procedures form Drive E 
MINIMAL1:=proc(F,F1,V,vars)
#option trace;
local f,flag,i,M,MM,N,t,j,W,k,H,G,K,KK,MN,MH;
	G := F;
	if G[1][1]=1 and G[1][2]=1 then
		if SNF(vars[2],F1,V,vars)=0 then
			KK := [0, 1];
		else
			KK := [1, 1];
		fi;
		W := NULL;
		for k in V do
			W := W, NormalForm(k, MonomTotal([KK],vars), plex(op(vars)));
		od;
		return([W],M^KK[1]*vars[2]^KK[2]);
	fi;
	if G[1][1]=1 then
		if SNF(vars[2]^G[1][2],F1,V,vars)=0 then
			return(MINIMAL3([[0, G[1][2]]], F1, V,vars));
		else
			flag:=false;
			for j from G[1][2]-1 to 1 by -1 while flag=false do
				MN := vars;
				N := NULL;
				for t in MN do
					if SNF(t*vars[2]^j,F1,V,vars)<>0 then
						flag := true;
					else
						N := N, t;
					fi;
				od;
			od;
			K := [1, j+2];
		fi;
		W := NULL;
		for k in V do
			W := W, NormalForm(k, MonomTotal([K],vars), plex(op(vars)));
		od;
		return([W],M^K[1]*vars[2]^K[2]);
	else
		flag := false;
		for i from G[1][1]-1 to 0 by -1 while flag=false do 
			MH := [MonomialMaker(i, vars)];
			N := NULL;
			for t in MH do 
				if SNF(t*vars[2]^(G[1][2]),F1,V,vars)<>0 then 
					flag := true;
				else 
					N := N, t;
				fi;
			od;
		od;
		H := [[i+2, G[1][2]]];
	fi;
	MM := MonomialMaker(i+2, vars);
	for f in H do
		if f[2]=1 then
			K := [i+2, 1];
		else
			flag := false;
			for j from f[2]-1 to 0 by -1 while flag=false do
				N := NULL;
				for t  in MM do 
					if SNF(t*vars[2]^(j),F1,V,vars)<>0 then
						flag := true;
					else
						N := N, t;
					fi;
				od;
			od;
			K := [i+2, j+2];
		fi;
	od;
	W := NULL;
	for k in V do
		W := W, NormalForm(k, MonomTotal([K],vars), plex(op(vars)));
	od;
	return ([W], M^K[1]*vars[2]^K[2]);
 end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################MINIMAL2
MINIMAL2:=proc(F,F1,V,vars)
#option trace;
local G,flag,i,MM,N,t,W,j; 
	G := F; 
	flag := false;
	for i from G[1][1]-1 to 1 by -1 while flag=false  do
		MM := [MonomialMaker(i, vars)];
		N := NULL;
		for t in MM do
			if SNF(t,F1,V,vars)<>0 then
				flag := true;
			else
				N := N, t;
			fi;
		od;
	od;
	W := NULL;
	for j in V do
		W := W, NormalForm(j, [MonomialMaker(i+2, vars)], plex(op(vars)));
	od;
	return([W], M^(i+2));
 end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######################################MINIMAL3
MINIMAL3:=proc(F,F1,V,vars)
#option trace;
local G,flag,i,N,W,j,K,q; 
	G := F;
	if G[1][2]=1 then
		if SNF(vars[2],F1,V,vars)=0 then
			K := vars[2];
		else
			K := 0;
		fi;
		W := NULL;
		for j in V do
			W := W, NormalForm(j, [K], plex(op(vars)));
		od;
		return(K);
	else
	#flag := false;
	#for i from G[1][2]-1 to 1 by -1 while flag=false do
	# N := NULL;
	#if SNF(lambda^(i),F1,V)<>0 then
	#  flag := true;
	# else 
	# N := N, i;
	# fi;
	#od;
	#q := lambda^(i+2);
	q:=vars[2]^(F[1][2]);
	fi;
	W := NULL;
	for j in V do
		W := W, NormalForm(j, [q], plex(op(vars)));
	od;
	 #return([W], lambda^(i+2));
	return([W], vars[2]^(F[1][2]));
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
######################################Main
modification:=proc(F,V,g,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K;
global F1;
	W := V;
	G := F;
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
						mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
						mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					 mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				 A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
				C := MINIMAL3([f], F1, W,vars);
				W := C[1];
		fi;
	od;
	a := NULL;
	for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
	od;
	L := `minus`({op(W)}, {0});
	K := add(i, i = [a]);
	print("T=",K+L);
	#print(T(g)=K+L);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
modificationnew:=proc(F,V,g,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, op_out;
global F1;
	W := V;
	G := F;
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				 else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
        od;
	a := NULL;
	for t in [mahsa] do 
#####Jan07,2018
                op_out := [op(t)];
                if nops(op_out)=2 and not type(op_out[2], integer) then
                     a := a, [degree(t,op_out[1]),degree(t,vars[2])];
               else
#######Jan07,2018
		a := a, [degree(t,M),degree(t,vars[2])];

              end if:
	od;
	return([a]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPERP:= proc (ff, V) 
#option trace;
local N,T,SortFun,II,q,MM,SB;
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
end:
N:=sort([N],SortFun);
II:=NULL;
for q in N do 
	if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
		if q[1]<>0 then
			MM:=[MonomialMaker(q[1], V)];
			II:=II,op(expand(V[2]^q[-1]*MM));
		elif q[2]<>0 then
			II:=II, V[2]^q[-1];
		fi;
	end if; 
end do; 
SB:=STD({II},V,Ds);   
N:=NSet([op(LM(SB))]);
return(N);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#########################################################Itr2 for change of coordinate
Itr2:=proc(Ideal,vars)
#option trace;
local F,S,LMS,flag,i,MaxPower,u,M,p,Monoms,m,NEWPOINT,esfahan;
	F:=Ideal;
	S:=STD(F,vars,Ds);
	LMS:=LM(S); 
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	#if indets(LMS[i])={x} then
	#flag:=true;
	#fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	#if indets(LMS[i])={lambda} then
	#flag:=false;
	#fi;
	# od;
	# if flag then
	#  RETURN("The ideal is of infinite codimension.");
	#fi;	
	#else
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {op(vars)} do         
		M:=MultMatrixFractional(S,u):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od: 
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower, vars)}:        
		for m in Monoms while flag do 
			if MoraNF(m,S)<>0 then                    
				flag:=false;
			else                     
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	return(MaxPower);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {}
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
######################################################################################Coefficient for S and X
Transformation:=proc(f,g,h,q)
	if _params['f'] <> NULL and _params['g'] <> NULL and _params['h'] = NULL and _params['q'] = NULL then
		ChangeofCoordinate1(f,g)
	elif _params['f'] <> NULL and _params['g'] <> NULL and whattype(g)=list and _params['h']<> NULL and whattype(h)=integer and _params['q'] = NULL then
		ChangeofCoordinate2(f,h,g)
	elif _params['f'] <> NULL and _params['g'] <> NULL and whattype(g)<>integer and _params['h']<> NULL and whattype(h)=list  and _params['q'] = NULL then
		ChangeofCoordinate3(f,g,h)
	elif _params['f'] <> NULL and _params['g'] <> NULL and whattype(g)<>integer and _params['h'] <> NULL and whattype(h)=list and _params['q']<> NULL and whattype(q)=integer then 
		ChangeofCoordinate4(f,g,q,h) 
	end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
##################################################################################Change of Coordinate
ChangeofCoordinate1:=proc(f,vars)
#option trace;
local g, p, h, ff, fff, LL, A, t, i, B, k, C, z, DD, j, W, MA, MB, qq, AQ, zz, ssss, KAZ, DDD, DDDD, MARI, ASADI, MAHSA, MAH, U, s, MAHH, AA, CC, BB, CD, ASD, ASA, S, X, AAa, BBb, hh, jan, man, HOS, aval, dovom, sevom, charom, panjom, jad1, jad2, jad3, r, a, wow, ava, dovo, sevo, charo, na, lam, bom, q1, q2, q3;
	p:=Itr2([vars[1]*f,vars[2]*f,vars[1]^2*diff(f,vars[1]),vars[2]*diff(f,vars[1])],vars);
	S:=add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1);
	X:=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1);
	g:=subs(a=1,NormalformFractional(mtaylor(f,vars,p+1),vars));
	h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1)*subs(vars[1]=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1),f),vars,p+3)));
	ff:=collect(h, [vars[2], vars[1]],`distributed`);
	fff:=sort(ff,order = tdeg(op(vars)), ascending);
	LL:=[op(fff)];
	A:=NULL;
	for t in LL do
		A:=A,degree(t,{op(vars)});
	od;
	for i from 1 to max(A) do 
		B[i]:=NULL;
	od;
	for k in LL do
		B[degree(k,{op(vars)})]:=B[degree(k,{op(vars)})],k;
	od;
	KAZ:=NULL;
	for i from min(A) to p+1 do #min(A)
		C[i]:=NULL;
		for z in  [op({B[i]}minus{0})] do
			if nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],integer)=true then
				C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
			elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],symbol)=true or nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],`^`)=true then
				 C[i]:=C[i],LeadingCoefficient(z,plex(op(vars)))=coeff(coeff(g,[op(z)][-1]),[op(z)][-2]);
			elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=1 then 
				 C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
			fi;
		od;
		DD:=solve({C[i]});#,indets([seq(LeadingCoefficient(z,plex(x,lambda)),z=[B[i]])]));
		if nops([DD])<>0 then
			for t in [DD] do
				if {a[0,0]=-1} subset t then
					 DD:=op({DD} minus {t});
				fi;
			od;
		fi;
		if nops([DD])<>0 then
			for t in [DD] do
				for r in t do
				#if type([op(p)][2],function) then
				#  DD:=op({DD} minus {t});
				 #fi;
					if [op(r)][1]=a[0,0] and type([op(r)][2],function) then
						 DD:=op({DD} minus {t});
					fi;
				od;
			od;
		fi;
		if nops([DD])<>0 then
			for t in [DD] do
				for k in t do
					if b[1,0]=op(1,k) and type(op(2,k),realcons)=true and op(2,k)>0 or b[1,0]=op(1,k) and b[1,0]=op(2,k) then 
						DD:=t;
					fi;
				od;
			od;
			DDD:=DD;
			DDDD:=NULL;
			for t in DDD do
				if type(op(2,t),function)=true then 
					DDDD:=DDDD,op(1,t)=[allvalues(op(2,t))][1];
				elif type(op(2,t),function)=false then
					DDDD:=DDDD,t;
				fi;
			od;
			KAZ:=KAZ,{DDDD};
			MARI:=[KAZ];
			ASADI:=DDDD;
			for j from i+1 to p+1 do 
				if whattype(op([{ASADI}][1])[1])=set then
					B[j]:=op(simplify(subs({ASADI}[1],[B[j]])));
				else
					B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));    
				fi;
				#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
			od;
		fi;
	od;
	MAHSA:=NULL;
	for t in MARI do
		MAHSA:=MAHSA,[t,{seq([op(j)][1],j=t)}];
	od;
		MAH:=[MAHSA];
	for i from 1 to nops(MAH)-1 do
		a:=MAH[i];
		for t in MAH[i][1] do
			if evalb(t)=true and {[op(t)][1]} subset MAH[i+1][2] then
				 MAH[i][1]:=MAH[i][1] minus {t};
			else
				MAH[i][1]:=MAH[i][1];
			fi;
		od;
	od;
	wow:={seq(op(i[1]),i=MAH)};
	#print(wow);
	ava:=NULL;
	dovo:=NULL;
	sevo:=NULL;
	charo:=NULL;
	for t in wow do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		elif evalb(t)=true then
			ava:=ava,[op(t)][1]=1;
		else
			dovo:=dovo,t;
		fi;
        od;
	na:=subs([ava],[dovo]);
	for t in na do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			sevo:=sevo,t;
		fi;
	 od;
	lam:=subs([ava],[sevo]);
	for t in lam do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			charo:=charo,t;
		fi; 
	od;
	bom:=subs([ava],[charo]);
	S:=subs([op(bom),ava],S);
	q1:=indets(S) minus {op(vars)};
	S:=subs([seq(i=0,i=q1)],S);
	X:=subs([b[0,0]=0,op(bom),ava],X);
	q2:=indets(X) minus {op(vars)};
	X:=subs([seq(i=0,i=q2)],X);
	h:=subs([b[0,0]=0,op(bom),ava],h);
	q3:=indets(h) minus {op(vars)};
	h:=subs([seq(i=0,i=q3)],h);
	 return("X"=X, "S"=S,"h"=h);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
ChangeofCoordinate3:=proc(f,gg,vars)
#option trace;
local  p, h, ff, fff, LL, A, t, i, B, k, C, z, DD, j, W, MA, MB, qq, AQ, zz, ssss, KAZ, DDD, DDDD, MARI, ASADI, MAHSA, MAH, U, s, MAHH, AA, CC, BB, CD, ASD, ASA, S, X, AAa, BBb, hh, jan, man, HOS, aval, dovom, sevom, charom, panjom, jad1, jad2, jad3, r, a, wow, ava, dovo, sevo, charo, na, lam, bom, q1, q2, q3,g;
#g:=subs(a=1,NormalformFractional(f));
	p:=Itr2([vars[1]*f,vars[2]*f,vars[1]^2*diff(f,vars[1]),vars[2]*diff(f,vars[1])],vars);
	S:=add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1);
	X:=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1);
	g:=mtaylor(gg,vars,p+1);
	h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1)*subs(vars[1]=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..p-1-i),i=0..p-1),f),vars,p+3)));
	ff:=collect(h, [vars[2],vars[1]],`distributed`);
	fff:=sort(ff,order = tdeg(op(vars)), ascending);
	LL:=[op(fff)];
	A:=NULL;
	for t in LL do
		 A:=A,degree(t,{op(vars)});
	od;
	for i from 1 to max(A) do 
		B[i]:=NULL;
	od;
	for k in LL do
		B[degree(k,{op(vars)})]:=B[degree(k,{op(vars)})],k;
	od;
	KAZ:=NULL;
	for i from min(A) to p+1 do #min(A)
	C[i]:=NULL;
	for z in  [op({B[i]}minus{0})] do
		 if nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],integer)=true then
			C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
		elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],symbol)=true or nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],`^`)=true then
			C[i]:=C[i],LeadingCoefficient(z,plex(op(vars)))=coeff(coeff(g,[op(z)][-1]),[op(z)][-2]);
		elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=1 then 
			C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
		fi;
	od;
	DD:=solve({C[i]});#,indets([seq(LeadingCoefficient(z,plex(x,lambda)),z=[B[i]])]));
	if nops([DD])<>0 then
		for t in [DD] do
			if {a[0,0]=-1} subset t then
				DD:=op({DD} minus {t});
			fi;
		od;
	fi;
	if nops([DD])<>0 then
		for t in [DD] do
			for r in t do
			#if type([op(p)][2],function) then
			# DD:=op({DD} minus {t});
			#fi;
				if [op(r)][1]=a[0,0] and type([op(r)][2],function) then
					DD:=op({DD} minus {t});
				fi;
			od;
		 od;
	fi;
	if nops([DD])<>0 then
		for t in [DD] do
			for k in t do
				if b[1,0]=op(1,k) and type(op(2,k),realcons)=true and op(2,k)>0 or b[1,0]=op(1,k) and b[1,0]=op(2,k) then 
					DD:=t;
				fi;
			od;
		od;
		DDD:=DD;
		DDDD:=NULL;
		for t in DDD do
			if type(op(2,t),function)=true then 
				DDDD:=DDDD,op(1,t)=[allvalues(op(2,t))][1];
			elif type(op(2,t),function)=false then
				DDDD:=DDDD,t;
			fi;
		od;
		KAZ:=KAZ,{DDDD};
		MARI:=[KAZ];
		ASADI:=DDDD;
		for j from i+1 to p+1 do 
			if whattype(op([{ASADI}][1])[1])=set then
				B[j]:=op(simplify(subs({ASADI}[1],[B[j]])));
			else
				B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));    
			fi;
				#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
		od;
	fi;
od;
MAHSA:=NULL;
	for t in MARI do
		MAHSA:=MAHSA,[t,{seq([op(j)][1],j=t)}];
	od;
	MAH:=[MAHSA];
	for i from 1 to nops(MAH)-1 do
		a:=MAH[i];
		for t in MAH[i][1] do
			if evalb(t)=true and {[op(t)][1]} subset MAH[i+1][2] then
				 MAH[i][1]:=MAH[i][1] minus {t}; 
			else
				MAH[i][1]:=MAH[i][1];
			fi;
		od;
	od;
	wow:={seq(op(i[1]),i=MAH)};
	#print(wow);
	ava:=NULL;
	dovo:=NULL;
	sevo:=NULL;
	charo:=NULL;
	for t in wow do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		elif evalb(t)=true then
			ava:=ava,[op(t)][1]=1;
		else
			dovo:=dovo,t;
		fi;
	od;
	na:=subs([ava],[dovo]);
	for t in na do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			sevo:=sevo,t;
		fi;
	od;
	lam:=subs([ava],[sevo]);
	for t in lam do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			charo:=charo,t;
		fi; 
	od;
	bom:=subs([ava],[charo]);
	S:=subs([op(bom),ava],S);
	q1:=indets(S) minus {op(vars)};
	S:=subs([seq(i=0,i=q1)],S);
	X:=subs([b[0,0]=0,op(bom),ava],X);
	q2:=indets(X) minus {op(vars)};
	X:=subs([seq(i=0,i=q2)],X);
	h:=subs([b[0,0]=0,op(bom),ava],h);
	q3:=indets(h) minus {op(vars)};
	h:=subs([seq(i=0,i=q3)],h);
	 return("X"=X, "S"=S,"h"=h);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
##############################################################inja g va h ro taghir dadam havaset bashe
ChangeofCoordinate2:=proc(f,yy,vars)
#option trace;
local g, p, h, ff, fff, LL, A, t, i, B, k, C, z, DD, j, W, MA, MB, qq, AQ, zz, ssss, KAZ, DDD, DDDD, MARI, ASADI, MAHSA, MAH, U, s, MAHH, AA, CC, BB, CD, ASD, ASA, S, X, AAa, BBb, hh, jan, man, HOS, aval, dovom, sevom, charom, panjom, jad1, jad2, jad3, a, wow, ava, dovo, sevo, charo, na, lam, bom, q1, q2, q3;
	S:=add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1);
	X:=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1);
	p:=Itr2([vars[1]*f,vars[2]*f,vars[1]^2*diff(f,vars[1]),vars[2]*diff(f,vars[1])],vars);
	if yy<p then
		print("Degrees of high order terms start with=",p);
		return("The estimated degree must be higher than what you have taken.");
	fi;
		#g:=subs(a=1,NormalformFractional(f));
		g:=subs(a=1,NormalformFractional(mtaylor(f,vars,yy+2),vars));
		#h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*x^i*lambda^j,j=0..yy-1-#i),i=0..yy-1)*subs(x=add(add(b[i,j]*x^i*lambda^j,j=0..yy-1-i),i=0..yy-1),f),#[x,lambda],yy+2)));
		h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1)*subs(vars[1]=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1),mtaylor(f,vars,yy+2)),vars,yy+2)));
		ff:=collect(h, [vars[2],vars[1]],`distributed`);
		fff:=sort(ff,order = tdeg(op(vars)), ascending);
		LL:=[op(fff)];
		A:=NULL;
		for t in LL do
			A:=A,degree(t,{op(vars)});
		od;
		for i from 1 to max(A) do 
			B[i]:=NULL;
		od;
		for k in LL do
			B[degree(k,{op(vars)})]:=B[degree(k,{op(vars)})],k;
		od;
		KAZ:=NULL;
		for i from min(A) to yy do #min(A)
			C[i]:=NULL;
			for z in  [op({B[i]}minus{0})] do
				if nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],integer)=true then
					C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
				elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],symbol)=true or nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],`^`)=true then
					C[i]:=C[i],LeadingCoefficient(z,plex(op(vars)))=coeff(coeff(g,[op(z)][-1]),[op(z)][-2]);
				elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=1 then 
					C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
				  fi;
			od;
			DD:=solve({C[i]});#,indets([seq(LeadingCoefficient(z,plex(x,lambda)),z=[B[i]])]));
			if nops([DD])<>0 then
				for t in [DD] do
					if {a[0,0]=-1} subset t then
						DD:=op({DD} minus {t});
					fi;
				od;
			fi;
			if nops([DD])<>0 then
				for t in [DD] do
					for p in t do
					#if type([op(p)][2],function) then
					#  DD:=op({DD} minus {t});
					#fi;
						if [op(p)][1]=a[0,0] and type([op(p)][2],function) then
							DD:=op({DD} minus {t});
						fi;
					od;
				od;
			fi;
			if nops([DD])<>0 then
				for t in [DD] do
					for k in t do
						if b[1,0]=op(1,k) and type(op(2,k),realcons)=true and op(2,k)>0 or b[1,0]=op(1,k) and b[1,0]=op(2,k) then 
							DD:=t;
						fi;
					od;
				od;
				DDD:=DD;
				DDDD:=NULL;
				for t in DDD do
					if type(op(2,t),function)=true then 
						 DDDD:=DDDD,op(1,t)=[allvalues(op(2,t))][1];
					elif type(op(2,t),function)=false then
						DDDD:=DDDD,t;
					fi;
				od;
				KAZ:=KAZ,{DDDD};
				MARI:=[KAZ];
				ASADI:=DDDD;
				for j from i+1 to yy do 
					if whattype(op([{ASADI}][1])[1])=set then
						B[j]:=op(simplify(subs({ASADI}[1],[B[j]])));
					else
						B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));    
					fi;
						#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
				od;
				#for j from i+1 to yy do 
				#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
				#od;
			fi;
		od;
		MAHSA:=NULL;
		for t in MARI do
			MAHSA:=MAHSA,[t,{seq([op(j)][1],j=t)}];
		od;
		MAH:=[MAHSA];
		for i from 1 to nops(MAH)-1 do
			a:=MAH[i];
			for t in MAH[i][1] do
				if evalb(t)=true and {[op(t)][1]} subset MAH[i+1][2] then
					MAH[i][1]:=MAH[i][1] minus {t};
				  else
					MAH[i][1]:=MAH[i][1];
				fi;
			od;
		od;
		wow:={seq(op(i[1]),i=MAH)};
		#print(wow);
		ava:=NULL;
		dovo:=NULL;
		sevo:=NULL;
		charo:=NULL;
		for t in wow do
			if type([op(t)][2],integer) or type([op(t)][2],fraction) then
				ava:=ava,t;
			elif evalb(t)=true then
				ava:=ava,[op(t)][1]=1;
			else
				dovo:=dovo,t;
			fi;
		od;
		na:=subs([ava],[dovo]);
		for t in na do
			if type([op(t)][2],integer) or type([op(t)][2],fraction) then
				ava:=ava,t;
			else
				sevo:=sevo,t;
			fi;
		od;
		#print(kojooo,ava);
		lam:=subs([ava],[sevo]);#print(lam);
		for t in lam do
			if type([op(t)][2],integer) or type([op(t)][2],fraction) then
				 ava:=ava,t;
			else
				charo:=charo,t;
			fi; 
		od;
		bom:=subs([ava],[charo]);
		S:=subs([op(bom),ava],S);
		q1:=indets(S) minus {op(vars)};
		S:=subs([seq(i=0,i=q1)],S);
		X:=subs([b[0,0]=0,op(bom),ava],X);
		q2:=indets(X) minus {op(vars)};
		X:=subs([seq(i=0,i=q2)],X);
		h:=subs([b[0,0]=0,op(bom),ava],h);
		q3:=indets(h) minus {op(vars)};
		h:=subs([seq(i=0,i=q3)],h);
		return("X"=X, "S"=S,"h"=h);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

ChangeofCoordinate4:=proc(fk,gg,yy,vars)
#option trace;
local f,p, h, ff, fff, LL, A, t, i, B, k, C, z, DD, j, W, MA, MB, qq, AQ, zz, ssss, KAZ, DDD, DDDD, MARI, ASADI, MAHSA, MAH, U, s, MAHH, AA, CC, BB, CD, ASD, ASA, S, X, AAa, BBb, hh, jan, man, HOS, aval, dovom, sevom, charom, panjom, jad1, jad2, jad3, a, wow, ava, dovo, sevo, charo, na, lam, bom, q1, q2, q3,g;
#with(Groebner):
	f:=mtaylor(fk,vars,yy+1);
	S:=add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1);
	X:=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1);
	p:=Itr2([vars[1]*f,vars[2]*f,vars[1]^2*diff(f,vars[1]),vars[2]*diff(f,vars[1])],vars);
	if yy<p then
		print("Degrees of high order terms start with=",p);
		return("The estimated degree must be higher than what you have taken.");
	fi;
	g:=mtaylor(gg,vars,yy+1);
	#g:=subs(a=1,NormalformFractional(f));
	#g:=subs(a=1,NormalformFractional(mtaylor(f,[x,lambda],yy+2)));
	#h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*x^i*lambda^j,j=0..yy-1-#i),i=0..yy-1)*subs(x=add(add(b[i,j]*x^i*lambda^j,j=0..yy-1-i),i=0..yy-1),f),#[x,lambda],yy+2)));
	h:=subs(b[0,0]=0,(mtaylor(add(add(a[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1)*subs(vars[1]=add(add(b[i,j]*vars[1]^i*vars[2]^j,j=0..yy-1-i),i=0..yy-1),mtaylor(f,vars,yy+2)),vars,yy+2)));
	ff:=collect(h, [vars[2], vars[1]],`distributed`);
	fff:=sort(ff,order = tdeg(op(vars)), ascending);
	LL:=[op(fff)];
	A:=NULL;
	for t in LL do
		A:=A,degree(t,{op(vars)});
	od;
	for i from 1 to max(A) do 
		B[i]:=NULL;
	od;
	for k in LL do
		B[degree(k,{op(vars)})]:=B[degree(k,{op(vars)})],k;
	od;
	KAZ:=NULL;
	for i from min(A) to yy do #min(A)
		C[i]:=NULL;
		for z in  [op({B[i]}minus{0})] do
			if nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],integer)=true then
				C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
			elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],symbol)=true or nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=2 and type([op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))][2],`^`)=true then
				C[i]:=C[i],LeadingCoefficient(z,plex(op(vars)))=coeff(coeff(g,[op(z)][-1]),[op(z)][-2]);
			elif nops({op(simplify(z/LeadingCoefficient(z,plex(op(vars)))))})=1 then 
				C[i]:=C[i],coeff(z,simplify(z/LeadingCoefficient(z,plex(op(vars)))))=coeff(g,simplify(z/LeadingCoefficient(z,plex(op(vars)))));
			fi;
		od;
		DD:=solve({C[i]});#,indets([seq(LeadingCoefficient(z,plex(x,lambda)),z=[B[i]])]));
		if nops([DD])<>0 then
			for t in [DD] do
				if {a[0,0]=-1} subset t then
					DD:=op({DD} minus {t});
				fi;
			od;
		fi;
		if nops([DD])<>0 then
			for t in [DD] do
				for p in t do
					#if type([op(p)][2],function) then
					#  DD:=op({DD} minus {t});
					#fi;
					if [op(p)][1]=a[0,0] and type([op(p)][2],function) then
						DD:=op({DD} minus {t});
					fi;
				od;
			od;
		fi;
		if nops([DD])<>0 then
			for t in [DD] do
				for k in t do
					if b[1,0]=op(1,k) and type(op(2,k),realcons)=true and op(2,k)>0 or b[1,0]=op(1,k) and b[1,0]=op(2,k) then 
						DD:=t;
					fi;
				od;
			od;
			DDD:=DD;
			DDDD:=NULL;
			for t in DDD do
				if type(op(2,t),function)=true then 
					DDDD:=DDDD,op(1,t)=[allvalues(op(2,t))][1];
				elif type(op(2,t),function)=false then
					DDDD:=DDDD,t;
				fi;
			od;
			KAZ:=KAZ,{DDDD};
			MARI:=[KAZ];
			ASADI:=DDDD;
			for j from i+1 to yy do 
				if whattype(op([{ASADI}][1])[1])=set then
					B[j]:=op(simplify(subs({ASADI}[1],[B[j]])));
				else
					B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));    
				fi;
					#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
			od;
			#for j from i+1 to yy do 
			#B[j]:=op(simplify(subs([op([{ASADI}][1])],[B[j]])));
			#od;
		fi;
	od;
	MAHSA:=NULL;
	for t in MARI do
		MAHSA:=MAHSA,[t,{seq([op(j)][1],j=t)}];
	od;
	MAH:=[MAHSA];
	for i from 1 to nops(MAH)-1 do
		a:=MAH[i];
			for t in MAH[i][1] do
				if evalb(t)=true and {[op(t)][1]} subset MAH[i+1][2] then
					 MAH[i][1]:=MAH[i][1] minus {t};
				else
					MAH[i][1]:=MAH[i][1]
				fi;
			 od;
	od;
	wow:={seq(op(i[1]),i=MAH)};
	ava:=NULL;
	dovo:=NULL;
	sevo:=NULL;
	charo:=NULL;
	for t in wow do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		elif evalb(t)=true then
			ava:=ava,[op(t)][1]=1;
		else
			dovo:=dovo,t;
		fi;
	od;
	na:=subs([ava],[dovo]);
	for t in na do
		 if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			sevo:=sevo,t;
		fi;
	od;
	lam:=subs([ava],[sevo]);
	for t in lam do
		if type([op(t)][2],integer) or type([op(t)][2],fraction) then
			ava:=ava,t;
		else
			charo:=charo,t;
		fi; 
	od;
	bom:=subs([ava],[charo]);
	S:=subs([op(bom),ava],S);
	q1:=indets(S) minus {op(vars)};
	S:=subs([seq(i=0,i=q1)],S);
	X:=subs([b[0,0]=0,op(bom),ava],X);
	q2:=indets(X) minus {op(vars)};
	X:=subs([seq(i=0,i=q2)],X);
	h:=subs([b[0,0]=0,op(bom),ava],h);
	q3:=indets(h) minus {op(vars)};
	h:=subs([seq(i=0,i=q3)],h);
	return("X"=X, "S"=S,"h"=h);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
###################################################################It should be changed I put one part in Drive E 
GermRecognition:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q, op_S;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		 od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};	
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	if type(S, `+`) then#enabled on Aug14, 2017
	   op_S := {op(S)}
	else
	   op_S := {S};
	end if:
	#P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};#disabled on Aug14, 2017
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i=op_S)};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERP(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	print("S=",mahh);#h
	#print("Nonzero condition=",[AB]);
	print("S^{⊥}=",{op(SPERP(add(i,i=[op(P)]),vars))});#S^{⊥}(h)
	print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
germrecognition:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERP(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	#print("intrinsic generators=",P);
	 #print("S=",mahh);
	print("Nonzero condition=",[AB]);
	#print("SPERP=",SPERP(add(i,i=[op(P)]),[x,lambda]));
	print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################that code which combine both recognition
RecognitionProblemFractional:=proc(f,c,vars)
	if _params['c'] = NULL and  _params['vars'] <> NULL  then
		 germrecognition(NormalformFractional(mtaylor(f,vars,4),vars),vars)
	elif _params['c'] = universalunfolding and  _params['vars'] <> NULL then
		RECOGNITION(NormalformFractional(mtaylor(f,vars,6),vars),vars)
	end if:
 end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
##############################################recognition problem for universal unfolding/Tis capital to avoid some problems with Marc Package
ComplemenT:=proc(L,vars)
	return(Nset({op(MonomTotal(L,vars))}));
end:
#<-----------------------------------------------------------------------------
# Function: { TRDRegularChain }
# Description: { return regular chain part of a semi algebraic system}
# Calling sequence:
# { TRDRegularChain(rsas, R) }
# Input:
# { rsas : regular semi algebraic system }
# { R : polynomial ring }
# Output:
# { regular chain part of rsas}
#>-----------------------------------------------------------------------------

DERIVATIVE:=proc(NN,g,vars)
#option trace;
local MM,t,N,W;
	MM := NULL;
	for t in NN do
		if nops([op(t)])=1 and op(t)=1  then
			MM := MM, g;
		elif nops([op(t)])=1 and op(t)<>1  then
			MM := MM, diff(g, [`$`(t, degree(t))]);
		elif nops([op(t)])=2 and type([op(t)][2],integer)=true then
			MM := MM, diff(g, [`$`([op(t)][1], degree(t))]);
		elif nops([op(t)])=2 and type([op(t)][2],integer)=false then
			MM := MM, diff(g, `$`([op(t)][1], degree([op(t)][1])), `$`([op(t)][2], degree([op(t)][2])));
		fi;
	od;
	N := convert([MM], D);
	W := subs([vars[1] = 0, vars[2] = 0], N);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
FINDPOWER:=proc(L,K)
#option trace;
local Q,C,t;
	Q := L;
	C := K;
	for t in Q do
		if nops([op(t)])=1 then
			if  t in C  then	
				Q := subs(t = 0, Q);
			fi;
		elif nops([op(t)])=2 and  type([op(t)][1],integer)=true then
			if [op(t)][1]=0 and [op(t)][2]=0 and t in C then
				Q := subs(t = 0, Q);
			elif [ op(t)][2] in C then 
				Q := subs(t = 0, Q);
			fi;
		fi;
	od;
	Q;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
RECOGNITION:=proc(h,vars)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEW(h,vars),vars);
	d := SPERP(h, vars);
	ET := PRTT2(h,vars);
	B := [diff(g(op(vars)), `$`(vars[1], 1)), diff(g(op(vars)), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(op(vars)),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		 K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(op(vars)),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		E := NULL;
		for hh in k do
			if hh=0 then
				E := E, hh;
			elif {op( op(0,hh))}subset {op(vars)} then
				E := E, hh;
			else
				HH := subs(g = G, hh);
				E := E, HH;
		         fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
RECOGNITION_subs :=proc(h,vars)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEW(h,vars),vars);
	d := SPERP(h, vars);
	ET := PRTT2(h,vars);
	B := [diff(g(op(vars)), `$`(vars[1], 1)), diff(g(op(vars)), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(op(vars)),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		 K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(op(vars)),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		E := NULL;
		for hh in k do
			if hh=0 then
				E := E, hh;
			elif {op(op(0,hh))}subset {op(vars)} then 
				E := E, subs([vars[1]=0,vars[2]=0],diff(h,op(op(0,hh))));
			else
				HH := subs(g = G, hh);
				E := E, HH;
		         fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRNEW:=proc(ggg,vars)
#option trace;
local RNF,TT,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi,Kazemi1,Kazemi2,Kazemi3,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
	if II[4]<>0 then
		#print(RT(g)=II[3]+II[4]);
		Temp:=II[3]+II[4];
	else
		 #print(RT(g)=II[3]);
		Temp:=II[3];
	fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		 X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modificationnew([Kazemi3],Kazemi4,ggg,vars);
	#print(Kazemi3,Kazemi4);
	#return([Kazemi3]);
end:  
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------

DIVID:=proc(L)
#option trace;
local uncom, comm, t;
	uncom := NULL;
	comm := NULL;
	for t in L do
		if nops(t)=3 then
			if t[1][1]=t[1][2] and t[2][1]=t[2][2] and t[3][1]=t[3][2] then
				comm := comm, t;
			else
				uncom := uncom, t;
			fi;
		elif nops(t)=2 then
			if t[1][1]=t[1][2] and t[2][1]=t[2][2] then
				comm := comm, t;
			else
				uncom := uncom, t;
			fi;
		fi;
	od;
	return [[comm], [uncom]];
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PARTITION:=proc(H,n)
local A, t, i;
	A := NULL;
	t := H[1];
	for i from 1 to n do
		t := t+(H[2]-H[1])/n;
		A := A, t;
	od;
	return [A][1 .. -2];
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
EXTRACT:=proc(L)
#option trace;
local A,t;
	A := NULL;
	for t in L do
		if nops(t)=3 then
			if t[1][1]=t[1][2] and t[2][1]=t[2][2] and t[3][1]=t[3][2] then
				A := A, [t[1][1], t[2][1], t[3][1]];
			elif t[1][1]=t[1][2] and t[2][1]=t[2][2] and t[3][1]<>t[3][2] then
				A := A, seq([t[1][1], t[2][1], i], i = PARTITION(t[3], 6));
			elif t[1][1]=t[1][2] and t[2][1]<>t[2][2] and t[3][1]=t[3][2] then
				A := A, seq([t[1][1], i, t[3][1]], i = PARTITION(t[2], 6));
			elif t[1][1]<>t[1][2] and t[2][1]=t[2][2] and t[3][1]=t[3][2] then
				A := A, seq([i, t[2][1], t[3][1]], i = PARTITION(t[1], 6));
			elif t[1][1]<>t[1][2] and t[2][1]<>t[2][2] and t[3][1]<>t[3][2] then
				A := A, seq(seq(seq([i, j, k], i = PARTITION(t[1], 6)), j = PARTITION(t[2], 6)), k = PARTITION(t[3], 6));
			elif t[1][1]<>t[1][2] and t[2][1]<>t[2][2] and t[3][1]=t[3][2] then
				A := A, seq(seq([i, j, t[3][1]], i = PARTITION(t[1], 6)), j = PARTITION(t[2], 6));
			elif t[1][1]<>t[1][2] and t[2][1]=t[2][2] and t[3][1]<>t[3][2] then
				A := A, seq(seq([i, t[2][1], k], i = PARTITION(t[1], 6)), k = PARTITION(t[3], 6));
			elif t[1][1]=t[1][2] and t[2][1]<>t[2][2] and t[3][1]<>t[3][2] then
				A := A, seq(seq([t[1][1], j, k], j = PARTITION(t[2], 6)), k = PARTITION(t[3], 6));
			fi;
		elif nops(t)=2 then
			 if t[1][1]=t[1][2] and t[2][1]=t[2][2] then
				A := A, [t[1][1], t[2][1]];
			elif t[1][1]=t[1][2] and t[2][1]<>t[2][2] then
				A := A, seq([t[1][1], i], i = PARTITION(t[2], 6));
			elif t[1][1]<>t[1][2] and t[2][1]=t[2][2] then
				A := A, seq([i, t[2][1]], i = PARTITION(t[1], 6));
			elif t[1][1]<>t[1][2] and t[2][1]<>t[2][2] then
				A := A,seq(seq([i, j], i = PARTITION(t[1], 6)), j = PARTITION(t[2], 6));
			fi;
		fi;
	od;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------

SIG:=proc(l)
local a;
	if l=0 then
		a := 0;
	else
		a := sign(l);
	fi;
	return(a);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

SelfClassification:=proc(J,K,Vars)
#option trace;
local L, M, t, A, v, P, MAS, j;
	if nops(J[1])=3 then
		 P := [seq([i, subs([Vars[1] = i[3], Vars[2] = i[2], Vars[3] = i[1]], K)], i = J)];
		L := [seq([m[1], [seq(SIG(m[2][i]),i=1..nops(m[2]))]], m = P)];
	elif nops(J[1])=2 then
		P := [seq([i, subs([Vars[1] = i[2], Vars[2] = i[1]], K)], i = J)];
		 L := [seq([m[1], [seq(SIG(m[2][i]),i=1..nops(m[2]))]], m = P)];
	fi;
	MAS := L[1][2];
	for j in L[2..-1]do
		if {j[2]} subset {MAS}=false then
			MAS := MAS, j[2];
		fi;
	od;
	M := [MAS];
	for t from 1 to nops(M) do
		A[t] := NULL;
	od;
	for v from 1 to nops(L) do
		if L[v][2] in M then
			 member(L[v][2], M, 'k');
			A[k]:= A[k], L[v][1];
		fi;
	od;
	return(seq([A[k]], k = 1 .. nops(M)));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

FINALUNCOM:=proc(H,Vars)
local S, i, A, t, a, b;
	S := H;
	for i from 1 to nops(S) do
		A[i] := NULL;
	od;
	for t in S do
		a := EXTRACT([t]);
		b := SelfClassification([a], F,Vars);
		member(t, S, 'k');
		A[k] := A[k], b;
	 od;
	return(seq([A[k]], k = 1 .. nops(H)));   
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
MMain:=proc(G)
#option trace;
local A, t;
	A := NULL;
	for t in G do
		if nops(t)=1 then
			A := A, t[1][1];
		else
			A := A, seq(t[i][1], i = 1 .. nops(t));
		   fi;
	od;
	return(A);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
MMAIN:=proc(L)
local B,h;
	B := NULL;
	for h in L do
		if nops(h)=1 then
			B := B, h[1];
		else
			B := B, h[2];
		fi;
	od;
	return(B);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
part:=proc(G,vars)
local a, J, K, B, H, Di;
#option trace;
	a:=indets(G) minus {op(vars)};
#  Computing B
	J:=<G,diff(G,vars[1]),diff(G,vars[2])>;
	K:=EliminationIdeal(J,a);
	B:=IdealInfo:-Generators(K);
# Computing H
	J:=<G,diff(G,vars[1]),diff(G,vars[1]$2)>;
	H:=IdealInfo:-Generators(EliminationIdeal(J,a));   
# Computing D
	J:=<G,diff(G,vars[1]), subs(vars[1]=xx,G), subs(vars[1]=xx,diff(G,vars[1])), 1-w*(vars[1]-xx)>;
	Di:=IdealInfo:-Generators(EliminationIdeal(J,a));
	return([op(B),op(H),op(Di)]);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
Shortplot:=proc(H,vars)#L,Vars
#option trace;
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI, NA,L,Vars,B,i;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	FI:=SelfClassification([FAH,LAH],F,Vars);
	NA:=MMAIN([FI]);
	B:=Array(1..nops([NA]),1..1);
	for i from 1 to nops([NA]) do
		B[i,1]:=implicitplot(subs([seq(Vars[j]=[NA][i][-j],j=1..nops(Vars))],H=0),vars[2]=-40..40,vars[1]=-20..20,gridrefine=4):
	od;
	display(B);
	#seq(implicitplot(x^4-lambda*x+i[1]+i[2]*lambda+i[3]*x^2,x=-20..20,lambda=-20..20,gridrefine=4),i=[NA]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Short:=proc(H,vars)#L,Vars
#option trace;
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI, NA,L,Vars;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	FI:=SelfClassification([FAH,LAH],F,Vars);
	NA:=MMAIN([FI]);
	#seq(implicitplot(x^4-lambda*x+i[1]+i[2]*lambda+i[3]*x^2,x=-20..20,lambda=-20..20,gridrefine=4),i=[NA]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
ShortSpecial:=proc(HH,vars,s)#L,Vars
#option trace;
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI, NA,L,Vars,H;
	H:=mtaylor(HH,vars,s+1);
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	FI:=SelfClassification([FAH,LAH],F,Vars);
	NA:=MMAIN([FI]);
	#seq(implicitplot(x^4-lambda*x+i[1]+i[2]*lambda+i[3]*x^2,x=-20..20,lambda=-20..20,gridrefine=4),i=[NA]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
Completeplot:=proc(H,vars)
#option trace;
local R, F, cad, SA, MAH, BAH, EAH, FAH, FI,L,Vars,B,i,NA;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	#DAH:=SelfClassification([BAH],F);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	#LAH:=MMAIN([DAH]);
	#return(BAH,FAH);
	NA:=BAH,FAH;
	B:=Array(1..nops([NA]),1..1);
	for i from 1 to nops([NA]) do
		B[i,1]:=implicitplot(subs([seq(Vars[j]=[NA][i][-j],j=1..nops(Vars))],H=0),vars[2]=-40..40,vars[1]=-20..20,gridrefine=4):
	od;
	display(B);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
Complete:=proc(H,vars)
#option trace;
local R, F, cad, SA, MAH, BAH, EAH, FAH, FI,L,Vars;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);	
	#DAH:=SelfClassification([BAH],F);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	#LAH:=MMAIN([DAH]);
	return(BAH,FAH);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
CompleteSpecial:=proc(HH,vars,s)
#option trace;
local R, F, cad, SA, MAH, BAH, EAH, FAH, FI,L,Vars,H;
	H:=mtaylor(HH,vars,s+1);
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	#DAH:=SelfClassification([BAH],F);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	#LAH:=MMAIN([DAH]);
	return(BAH,FAH);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intermediateplot:=proc(H,vars)
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI,L,Vars,i,B,NA;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	#return(FAH,LAH);
	NA:=FAH,LAH;
	B:=Array(1..nops([NA]),1..1);
	for i from 1 to nops([NA]) do
		B[i,1]:=implicitplot(subs([seq(Vars[j]=[NA][i][-j],j=1..nops(Vars))],H=0),vars[1]=-2..2,vars[2]=-0.9..0.9,gridrefine=4):
	od;
	display(B);
end:  
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intermediate:=proc(H,vars)
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI,L,Vars;
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	return(FAH,LAH);
end:  
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntermediateSpecial:=proc(HH,vars,s)
local R, F, cad, SA, MAH, BAH, DAH, EAH, FAH, LAH, FI,L,Vars,H;
	H:=mtaylor(HH,vars,s+1);
	L:=part(H,vars);
	Vars:=[op({seq(op(indets(i)),i=L)})];
	L:=[op({seq(factor(i),i=L)})];
	R := PolynomialRing(Vars);
	F:=L;
	cad := CylindricalAlgebraicDecompose(F, R, output = list);
	SA := [seq(cad[i][2][2], i = 1 .. nops(cad))];
	MAH:=DIVID(SA);
	BAH:=EXTRACT(MAH[1]);
	DAH:=SelfClassification([BAH],F,Vars);
	EAH:=FINALUNCOM(MAH[2],Vars);
	FAH:=MMain([EAH]);
	LAH:=MMAIN([DAH]);
	return(FAH,LAH);
end:  
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
NonPersistent:=proc(a,b,c,d,f,g,h,q)
	if _params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d'] <> NULL and  _params['f'] <> NULL and  _params['g'] = NULL and _params['h']=NULL and _params['q']=NULL then
		 NonPersistentSource(a,b,c,d,f)
	elif params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d'] <> NULL and  _params['f'] <> NULL and  _params['g']<>NULL  and _params['h']<>NULL and _params['q']=NULL then 
		NonPersistentSource2(a,b,c,d,f,g,h)
	elif _params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d']<>NULL and _params['f']<> NULL and  _params['g'] =vertical  and _params['h']=NULL and _params['q']=NULL then 
		NonPersistentBound(a,b,c,d,f)
	elif _params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d']<>NULL and _params['f'] <> NULL and  _params['g'] <> NULL and _params['h']<>NULL and _params['q']=vertical then
		NonPersistentBound1(a,b,c,d,f,g,h)
	elif _params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d']<>NULL and _params['f']<>NULL and  _params['g'] = horizontal  and _params['h']=NULL and _params['q']=NULL then
		NonPersistentbound(a,b,c,d,f)
	elif _params['a'] <> NULL and _params['b'] <> NULL  and _params['c'] <> NULL and _params['d']<>NULL and _params['f'] <> NULL and  _params['g'] <> NULL and _params['h']<>NULL and _params['q']=horizontal then 
		NonPersistentbound1(a,b,c,d,f,g,h)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
##########################################################ino emal kon roye hame codha anyway
guide:=proc(g)
	if nops(indets(g))>=3 then
		return("The input germ must only depend on two scalar variables x, \lambda. Where x is the 
state variable and \lambda is a distinguished parameter: see also");
	elif nops(indets(g))=2 and evalb(indets(g)={x,\lambda})=false then
		return("User must determine what are the distinguished parameter and the state variable
: For example command(germ, (x,lambda)=(z,t))");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
ColonIdeal:=proc(L,g)
local M,LL;
	LL:=Intersect(<op(L)>,<g>);
	M:=[seq(simplify(i/g),i=Generators(LL))];
	return(M);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
##################### Computations in formal power series ring################
LTFormal:=proc(f,Vars,k)
local g, A, B, d, flag, N, i;
#option trace;
	g := expand(mtaylor(f,Vars,k+1));
	if type(g,`+`) then
		A := [op(g)];
		A:=sort(A,(a,b)->degree(a, Vars) < degree(b, Vars));
		d := degree(A[1]);
		flag := false;
		N := NULL;
		for i from 1 to nops(A) while flag=false do 
			if degree(A[i])=d then
				N := N, A[i];
			else
				flag := true;
			fi;
		od;
		B := [N];
		B:=sort(B,(a,b)->TestOrder(b, a, plex(op(Vars))));
		RETURN(B[1]);
	else
		RETURN(g);
	fi;
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
DivAlgFormal:=proc(f,L,k,Vars)
#option trace;
local h, N, lt, M, l, A, B, Mahsa, t, W;
	h := mtaylor(f, Vars, k+1);
	N := [seq(mtaylor(g, Vars, k+1), g in L)];
	N:=sort(N,(a,b)->TestOrder(LMFormal(a, Vars,k), LMFormal(b, Vars,k), plex(op(Vars))));
	lt := LTFormal(h, Vars,k);
	A := NULL;
	while degree(lt)<= k and lt<>0 and h<>0 do
		l:=z->divide(lt, LTFormal(z, Vars,k));
		M := select(l, N);
		if nops(M)<>0 then
			h := simplify(h-lt*M[1]/LTFormal(M[1], Vars,k));
			lt := LTFormal(h, Vars,k);
			A := NULL;
		elif nops(M)=0 and whattype(h)= `+`  then
			A := A, lt;
			lt := LTFormal(h-add(i, i = [A]), Vars,k);
			if add(i,i=[A])=h then
				B := [op(h)];
				Mahsa := NULL;
				for t in B do
					l:=z->divide(t, LTFormal(z, Vars,k));
						W := select(l, N);
						Mahsa := Mahsa, op(W);
				od;
				if nops({Mahsa})=0 then
					 return(h);
				fi;
			 fi;
		elif nops(M)=0 and whattype(h)= `*`  then 
			return (h);
		elif nops(M)=0 and whattype(h)= `^` then
			return(h);
		elif nops(M)=0 and whattype(h)= symbol then
			return(h);
		elif nops(M)=0 and whattype(h)= integer then
			return(h);
		fi;
        od;return(mtaylor(h,Vars,k+1));
        end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
LMFormal:=proc(f,Vars,k)
	return(LeadingMonomial(LTFormal(f, Vars,k), plex(op(Vars))));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
SpolyFormal:=proc(f,g,Vars,k)
local a;
	a := lcm(LMFormal(f, Vars,k), LMFormal(g, Vars,k));
	return(simplify(a*f/LTFormal(f, Vars,k)-a*g/LTFormal(g, Vars,k)));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
MAHSa:=proc(L)
local A, BB, i, m, W;
#option trace;
	A := L;
	BB := NULL;
	for i in A do
		m := A[1];
		A := A[2 .. -1];
		W := [seq([m, j], j in A)];
		BB := BB, op(W);
	od;
	return([BB]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------

MAHSa:=proc(L)
local A, BB, i, m, W;
#option trace;
	A := L;
	BB := NULL;
	for i in A do
		m := A[1];
		A := A[2 .. -1];
		W := [seq([m, j], j in A)];
		BB := BB, op(W);
	od;
	return([BB]);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
StandardBasisFormal:=proc(F,Vars,k)
#option trace;
local G, P, A, B, h, Q, i,high;
	G := [seq(mtaylor(i,Vars,k+1),i=F)];
	high:=Itr2(G,Vars);
	if k<high and evalb({op(G)}={op(F)})=false then
		print("The truncation degree is not sufficiently high and thus the following results might be wrong.");
		print("The permissible truncation degree starts with degree=",high);
	fi;
	P := MAHSa(G);
	while nops(P)<>0 do
		A := P[1];
		B := SpolyFormal(A[1], A[2], Vars,k);
		h := DivAlgFormal(B, G, k, Vars);
		P := P[2 .. -1];
		if h<>0 then 
			Q := NULL;
			for i in G do
				Q := Q, [h, i];
			od;
			P := [op(P), Q];
			G := [op(G), h];
		fi;
	od;
	#return(G);
	return(REDUCEDFormal(G, Vars, k));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
REDUCEDFormal:=proc(F,vars,di)
#option trace;
local L, i, A, t, S, B, j, a, C,Vars,d;
	Vars := vars;
	d := di;
	L := F;
	for i in F do
		A := subs(i = NULL, L);
		for t in A do
			if divide(LTFormal(i,Vars,d),LTFormal(t,Vars,d))=true then
				 L:=[op({op(subs(i=DivAlgFormal(i,A,d,Vars),L))} minus {0})];
			fi;
		od;
	od;
	S := L;
	B := NULL;
	for j in L do
		a := LTFormal(j, Vars,d);
		B := B, a+DivAlgFormal(j-a, S, d, Vars);
	od;
	C := [seq(f/LeadingCoefficient(LTFormal(f, Vars,d), plex(op(Vars))), f = [B])];
	 return(C);
 end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
NormalformFormal:=proc(ggg,vars,z,k)
	if _params['ggg'] <> NULL and _params['vars'] <> NULL and _params['z'] <> NULL and whattype(z)=integer  and _params['k']=NULL  then
		NF2Formal(ggg,vars,z)
	elif _params['ggg'] <> NULL and  _params['vars'] <> NULL and _params['z'] = list  and _params['k'] <> NULL and whattype(k)=integer then
		NF1Formal(ggg,vars,k)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
NF1Formal:=proc(ggg,vars,k)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	t1:=kernelopts(cputime);
	g:=ggg;#subs(lambda=y,ggg);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	Sprim:=[mtaylor(vars[1]*g,vars,k),mtaylor(vars[2]*g,vars,k),mtaylor(vars[1]^2*diff(g,vars[1]),vars,k),mtaylor(vars[2]*diff(g,vars[1]),vars,k)];
	high:=Itr2(Sprim,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		print("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1Formal(S,vars,k);
	P0:={op(IT[1])};
	g:=NormalForm(mtaylor(g,vars,k+1),P0,plex(op(vars)));#I chnaged g into mtaylor of g.
	Sperp:={op(IG2Formal(g,vars,k)[-1])}; 
	Pperp:={op(NSetFormal([seq(LMFormal(f,vars,k),f=StandardBasisFormal(P0,vars,k))],vars,k))};
	A:=Pperp minus Sperp;
	C:={op(IG2Formal(g,vars,k)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		if LeadingMonomial(g,plex(op(vars)))in B then
			 Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			 for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			od;
		od;
		d:=d-1;
	od;
	H:=seq(expand(subs(op(s),g)),s=[SS]);
	RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################second one inja sprime ro az k+1 be k tabdil kardam..vali sure nistam faghat vase inke mese baghi bashe..
NF2Formal:=proc(ggg,vars,k)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,high,Sprim;
	g:=ggg;#subs(lambda=y,ggg);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	Sprim:=[mtaylor(vars[1]*g,vars,k),mtaylor(vars[2]*g,vars,k),mtaylor(vars[1]^2*diff(g,vars[1]),vars,k),mtaylor(vars[2]*diff(g,vars[1]),vars,k)];
	high:=Itr2(Sprim,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		return("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1Formal(S,vars,k);
	P0:={op(IT[1])};
	g:=NormalForm(mtaylor(g,vars,k+1),P0,plex(op(vars)));
	Sperp:={op(IG2Formal(g,vars,k)[-1])}; 
	Pperp:={op(NSetFormal([seq(LMFormal(f,vars,k),f=StandardBasisFormal(P0,vars,k))],vars,k))};
	A:=Pperp minus Sperp;
	C:={op(IG2Formal(g,vars,k)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		if LeadingMonomial(g,plex(op(vars)))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				 fi;
			 od;
		 od;
		if flag then
			d:=d-1;
		fi;
	od;
	g:=expand(subs(ss,g));
	RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
Itr1Formal:=proc(Ideal,vars,k)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	#F:=[g,lambda*diff(g,x),x*diff(g,x)];
	F:=Ideal;
	S:=StandardBasisFormal(F,vars,k);
	LMS:=[seq(LMFormal(f,vars,k),f=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	#flag:=true;
	 #fi;
	#od;
	#if flag then
	 #for i from 1 to nops(S) while flag do
	 #if indets(LMS[i])={lambda} then
         #flag:=false;
       #fi;
	#od;
	# if flag then
       #RETURN("The ideal is of infinite codimension.");
	#fi;
	#else
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {op(vars)} do         
		M:=MultMatrixFormal(S,u,vars,k):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower, vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if DivAlgFormal(m,S,k,vars)<>0 then                    
				flag:=false;
			else         
				#RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i, vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if DivAlgFormal(m,S,k,vars)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(kk,j,vars)
	if degree(kk,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
j:=1;
ind:=MaxPower;
while MM<>{} do
	MM:=select(SelFun,M,j,vars);
	MMM:={seq(expand(m/vars[2]^j),m=MM)};
	if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
		OUT:=OUT,[0,degree(MM[1])]; 
		M:=M minus {MM[1]}; 
	else
		B:=MaxPower;
		for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
			MX:={MonomialMaker(i, vars)};
			if MX subset MMM then
				flag:=true;
				#OUT:=OUT,[i,j];
				B:=min(B,i);
				#M:=M minus {seq(lambda*mx,mx=MX)};
			fi;
		od;
		if flag and B+j < ind then
			OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		j:=j+1;
	fi;
od;
L:=[MonomialMaker([OUT][1][1], vars),seq(op(expand([MonomialMaker([OUT][i][1], vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
Y:=seq(DivAlgFormal(F[i],L,k,vars),i=1..nops(F));
M:='M';
#L:=subs(y=lambda,L);
#FF:=subs(y=lambda,F);
NN:=expand(subs(y=vars[2],{seq(DivAlgFormal(F[i],L,k,vars),i=1..nops(F))})) minus {0};
L:=subs(y=vars[2],L);
NN:={seq(NormalForm(g,L,plex(op(vars))),g=NN)};
if NN={} then
	RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
else
	RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
#	RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN);
fi;
	#RETURN(OUT);  
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
MultMatrixFormal:=proc(S,u,vars,k)
local L,n,M,i,v,j,c;
#option trace;
	L:=NSett([seq(LMFormal(f,vars,k),f=S)]);
	n:=nops(L);
	M:=Matrix(n);
	for i from 1 to n do
		v:=DivAlgFormal(u*L[i],S,k,vars);
		M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				 M[j,i]:=c;
			fi;
		od;
	od;
	RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
IG2Formal:= proc (ff, V,k) 
#option trace;
local II,M,N,T,SortFun,S,NN,NNN,C,ZC,MaxPowerOfM,MinPowerOfMl,flag,q,L,i,MM,SB,ll;
	M:='M';
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		 if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
end:
N:=sort([N],SortFun);
S := 0;
NN := 0;
NNN := 0;
C := NULL;
ZC:=NULL;
II:=NULL;
MaxPowerOfM:=0;
MinPowerOfMl:=infinity;
flag:=false;
for q in N do 
    if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
        if q[-1] <> 0 then 
            if q[1]<>0 and (not flag or q[1]+q[-1]<MaxPowerOfM) then
                NN := NN+M^q[1]*`<,>`(V[2]^q[-1]);
                NNN := NNN,V[1]^q[1]*V[2]^q[-1];
                C:=C,Diff(f,V[1]$q[1],V[2]$q[2]); 
                MinPowerOfMl:=min(MinPowerOfMl,q[1]+q[-1]);
            elif q[1]=0 and (not flag or q[1]+q[-1]<MaxPowerOfM) and (q[-1]<MinPowerOfMl) then
                    NN := NN+`<,>`(V[2]^q[-1]);
                    NNN := NNN,V[1]^q[1]*V[2]^q[-1];
                    C:=C,Diff(f,V[1]$q[1],V[2]$q[2]);                 
            fi;
        elif q[1]<>0 and not flag then
            NN := NN+M^q[1];
            NNN := NNN,V[1]^q[1];
            C:=C,Diff(f,V[1]$q[1]);
            MaxPowerOfM:=q[1]; 
            flag:=true;
        end if; 
        #NNN := NNN,x^q[1]*lambda^q[-1]; 
        #C := C, diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))<>0; 
        #L:=NULL;
        #for i from 1 to nops(V) do
        #    if q[i]<>0 then
        #        L:=L,seq(V[i],j=1..q[i]);
        #    fi;
        #od;
        #if L=NULL then
        #    C:=C,f<>0;
        #else
        #    C := C, Diff(f,subs(y=lambda,[L]))<>0; 
        #fi;
        if q[1]<>0 then
            MM:=[MonomialMaker(q[1], V)];
            II:=II,op(expand(V[2]^q[-1]*MM));
        elif q[2]<>0 then
            II:=II, V[2]^q[-1];
        fi;
    end if; 
end do;  
SB:=StandardBasisFormal([II],V,k);  
N:=NSetFormal([seq(LMFormal(f,V,k),f=SB)],V,k);
ll:=1;
if  1 in N then
    ZC:=f=0;
    ll:=2;
fi;
ZC:=[ZC,seq(Diff(f,V[1]$degree(v,V[1]),V[2]$degree(v,V[2]))=0,v in N[ll..-1])];
RETURN(NN, {NNN} minus {0}, C ,N); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
NSetFormal := proc (LL,vars,k) 
#option trace;
local g,L,V, d, N, v, x, m, i, j, u, flag, l; 
	L:={seq(LMFormal(f,vars,k),f=LL)};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
PRTT2Formal:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Formal(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduceFormal(II[5] union R0,k,vars)),set);
		Kazemi4:=convert(expand(IntInterReduceFormal(II[5] union R0,k,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduceFormal(R0,k,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduceFormal(R0,k,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		 RRefined:=RRefined,IntDivAlgFormal(r,{RRefined} union S minus {r},k,vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([seq(LMFormal(f,vars,k),f=SB)]);
	RNF:=IntInterReduceFormal(RNF,k,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlgFormal(h,{op(RNF),H},k,vars);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------

PRTT2newFormal:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Formal(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			 #print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([seq(LMFormal(f,vars,k),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg1(h,{op(RNF),H},[vars[2],vars[1]]);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfoldingFormal:=proc(a,b,vars,c,k)
if _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=integer and _params['vars'] <> NULL  and _params['c'] = NULL and _params['k']= NULL  then
	UniversalUnfolding1Formal(a,vars,b)[1]
elif _params['a']<>NULL and _params['b'] = list  and _params['vars'] <> NULL and _params['c'] <> NULL and whattype(c)=integer and _params['k']=NULL  then
	UniversalUnfolding2Formal(a,vars,c)[1]
elif _params['a']<>NULL and _params['b'] = normalform  and _params['vars'] <> NULL and _params['c'] <> NULL and whattype(c)=integer and _params['k']=NULL then 
	UniversalUnfolding1Formal(a,vars,c)[2]
elif _params['a']<>NULL and _params['b'] = normalform  and _params['vars'] <> NULL and _params['c'] = list and _params['k'] <> NULL and whattype(k)=integer then  
	UniversalUnfolding2Formal(a,vars,k)[2]
fi;  
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding1Formal:=proc(g,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET:=PRTT2Formal(g,vars,k);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformFormal(g,vars,k)+add(alpha[i]*ET[i],i=1..nops(ET));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding2Formal:=proc(g,vars,k)
#option trace;
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4;
	#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET1:=PRTT2Formal(g,vars,k);
	ET2:=PRTT2newFormal(g,vars,k);
	G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
	G3:=NormalformFormal(g,vars,k)+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G4:=NormalformFormal(g,vars,k)+add(alpha[i]*ET2[i],i=1..nops(ET2));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([[G1,G2],[G3,G4]]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic1Formal:=proc(L,vars, k)
#option trace;
local firsttime, firstbytes, II;
firsttime, firstbytes := kernelopts(cputime, bytesused);
	II:=Itr1Formal(L,vars,k);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic2Formal:=proc(F,V,vars,k)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
 global F1;
	Kazemi1:=Itr1Formal(F,vars,k)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1Formal(F,vars,k)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				 A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				 W := A[1];
			 fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				 mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
            od;
            a := NULL;
            for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
            od;
            L := `minus`({op(W)}, {0});
            K := add(i, i = [a]);
            print("Intrinsic part is=",K);
            end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntrinsicFormal:=proc(U,V,vars,k)
if _params['U']<>NULL and _params['V']=NULL and  _params['vars']<>NULL and _params['k']<>NULL then
	Intrinsic1Formal(U,vars,k)
elif _params['U']<>NULL and _params['V']<>NULL and _params['vars']<>NULL and  _params['k']<>NULL then
	Intrinsic2Formal(U,V,vars,k)
fi;
end:  
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {}
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
SPERPFormal:= proc (ff, V,k) 
#option trace;
local N,T,SortFun,II,q,MM,SB;
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
	end:
	N:=sort([N],SortFun);
	II:=NULL;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
			if q[1]<>0 then
				MM:=[MonomialMaker(q[1], V)];
				II:=II,op(expand(V[2]^q[-1]*MM));
			elif q[2]<>0 then
				II:=II, V[2]^q[-1];
			fi;
		end if; 
	end do; 
	SB:=StandardBasisFormal([II],V,k);
	N:=NSett([seq(LMFormal(f,V,k),f=SB)]);
	return(N);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionFormal:=proc(h,vars,k)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPFormal(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	print("S=",mahh);#(h)out
	#print("Nonzero condition=",[AB]);
	print("S^{⊥}=",{op(SPERPFormal(add(i,i=[op(P)]),vars,k))});#S^{⊥}(h)
	print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
AlgObjectsFormal:=proc(ggg,vars,k)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Formal(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSett([seq(LMFormal(f,vars,k),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognitionFormal(g,vars,k));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
germrecognitionFormal:=proc(h,vars,k)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPFormal(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	#print("intrinsic generators=",P);
	#print("S=",mahh);
	print("Nonzero condition=",[AB]);
	#print("SPERP=",SPERP(add(i,i=[op(P)]),[x,lambda]));
	print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRNEWFormal:=proc(ggg,vars,k)
#option trace;
local Kazemi,TT,Kazemi1,Kazemi2,Kazemi3,Kazemi4,RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Formal(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modificationnew([Kazemi3],Kazemi4,ggg,vars);
	#print(Kazemi3,Kazemi4);
	#return([Kazemi3]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
RECOGNITIONFormal:=proc(h,vars,kk)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEWFormal(h,vars,kk),vars);
	d := SPERPFormal(h,vars,kk);
	ET := PRTT2Formal(h,vars,kk);
	B := [diff(g(vars[1], vars[2]), `$`(vars[1], 1)), diff(g(vars[1], vars[2]), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(op(vars)),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(vars[1], vars[2]),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			 else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		 E := NULL;
		for hh in k do
			if hh=0 then
				 E := E, hh;
			elif {op( op(0,hh))}subset {op(vars)} then
				E := E, hh;
			else
				HH := subs(g = G, hh);
				E := E, HH;
			fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
RecognitionProblemFormal:=proc(f,vars,c,k)
	if _params['f'] <>NULL and _params['vars'] <>NULL  and _params['c'] <> NULL  and whattype(c)=integer and _params['k']=NULL then
		germrecognitionFormal(NormalformFormal(mtaylor(f,vars,4),vars,c),vars,c)
	elif _params['f'] <>NULL and _params['vars'] <>NULL and _params['c'] = universalunfolding and _params['k'] <>NULL and
		whattype(k)=integer then
		RECOGNITIONFormal(NormalformFormal(mtaylor(f,vars,6),vars,k),vars,k)
	end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
################Computations in ring of smooth germs###########################
LTGerm:=proc(f,de,Vars)
local g, A, B, d, flag, N, h, i;
#option trace;
	h := expand(f);
	g := mtaylor(h, Vars, de);
	if type(g,`+`) then
		A := [op(g)];
		A:=sort(A,(a,b)->degree(a) < degree(b));
		d := degree(A[1]);
		flag := false;
		N := NULL:
		for i from 1 to nops(A) while flag=false do 
			if degree(A[i])=d then
				N := N, A[i];
			else
				flag := true;
			fi;
		od;
		B := [N];
		B:=sort(B,(a,b)->TestOrder(b, a, plex(op(Vars))));
		RETURN(B[1]);
	else
		RETURN(g);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
LMGerm:=proc(f,de,Vars)
	return(LeadingMonomial(LTGerm(f, de, Vars), plex(op(Vars))));
end:

#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
TEST:=proc(F,K,Vars)
	if degree(F)<degree(K) then
		return(false);
	elif degree(F)>degree(K) then
		return(true);
	elif degree(F)=degree(K) and TestOrder(F,K,plex(op(Vars)))=true then
		return(true);
	elif degree(F)=degree(K) and TestOrder(F,K,plex(op(Vars)))=false then
		return(false);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
DivAlgGerm:=proc(f,L,k,Vars)
#option trace;
local h, N, lt, M, l, A, B, Mahsa, t, W, z;
	h := f;
	N := [seq(g, g in L)];
	N:=sort(N,(a,b)->TEST(LMGerm(a, k+1, Vars), LMGerm(b, k+1, Vars), Vars));
	lt := LTGerm(h, k+1, Vars);
	A := NULL;
	 while degree(lt)<= k  and lt<>0 and h<>0 do
		M := NULL;
		for z in N do 
			if LTGerm(z,k+1,Vars)<>0  and divide(lt,LTGerm(z,k+1,Vars))=true then 
				 M := M, z;
			fi;
		od;
		M := [M];
		 if nops(M)<>0 then
			 h := simplify(h-lt*M[1]/LTGerm(M[1], k+1, Vars));
			lt := LTGerm(h, k+1, Vars);
			A := NULL;
		elif nops(M)=0 and whattype(h)= `+`  then
			A := A, lt;
			lt := LTGerm(h-add(i, i = [A]), k+1, Vars);
			if add(i,i=[A])=h then
				B := [op(h)];
				Mahsa := NULL;
				W := NULL;
				for t in B do
					for z in N do 
						if LTGerm(z,k+1,Vars)<>0  and divide(t,LTGerm(z,k+1,Vars))=true then 
								W := W, z;
						fi;
					od;
					 Mahsa := Mahsa, op([W]);
				od;
			if nops({Mahsa})=0 then
					return(mtaylor(h,Vars,k+1));
			fi;
			fi;
		elif nops(M)=0 and whattype(h)= `*`  then 
				return(mtaylor(h,Vars,k+1));
		elif nops(M)=0 and whattype(h)= integer  then 
				return(mtaylor(h,Vars,k+1));
		elif nops(M)=0 and whattype(h)= `^` then
				return(mtaylor(h,Vars,k+1));
		elif nops(M)=0 and whattype(h)= symbol then
				return(mtaylor(h,Vars,k+1));
		fi;
	od;return(mtaylor(h,Vars,k+1));  
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SpolyGerm:=proc(f,g,k,Vars)
#option trace;
local a;
	if mtaylor(f,Vars,k+1)=0 or  mtaylor(g,Vars,k+1)=0 then
		return(0);
	else
		a := lcm(LMGerm(f, k+1, Vars), LMGerm(g, k+1, Vars));
		return(simplify(a*f/LTGerm(f, k+1, Vars)-a*g/LTGerm(g, k+1, Vars)));
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
MAh:=proc(L)
local A, BB, i, m, W;
#option trace;
	A := L;
	BB := NULL;
	for i in A do
		m := A[1];
		A := A[2 .. -1];
		W := [seq([m, j], j in A)];
		BB := BB, op(W);
	od;
	return([BB]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {}
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
StandardBasisGerm:=proc(F,Vars,k)
#option trace;
local G, P, A, B, h, Q, i;
	G := F;
	P := MAh(G);
	while nops(P)<>0 do
		A := P[1];
		B := SpolyGerm(A[1], A[2], k, Vars);
		h := DivAlgGerm(B, G, k, Vars);
		P := P[2 .. -1];
		if mtaylor(h,Vars,k+1)<>0 then 
			Q := NULL;
			for i in G do
				Q := Q, [h, i];
			od;
			P := [op(P), Q];
			G := [op(G), h];
		fi;
	od;
	#return(G);
	return(REDUCEDGerm(G, Vars, k));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
REDUCEDGerm:=proc(F,vars,di)
#option trace;
local L, i, A, t, S, B, j, a, C, Vars, d;
	Vars := vars;
	d := di;
	L := F;
	for i in F do
		A := subs(i = NULL, L);
		for t in A do
			if divide(LTGerm(i,d+1,Vars),LTGerm(t,d+1,Vars))=true then
				L:=[op({op(subs(i=DivAlgGerm(i,A,d,Vars),L))} minus {0})];
			fi;
		od;
	od;
	S := L;
	B := NULL;
	for j in L do
		a := LTGerm(j, d+1, Vars);
		B := B, a+DivAlgGerm(j-a, S, d+1, Vars);
	od;
		C := [seq(f/LeadingCoefficient(LTGerm(f, d+1, Vars), plex(op(Vars))), f = [B])];
		return(C);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
NormalformGerm:=proc(ggg,vars,z,k)
	if _params['ggg'] <> NULL and _params['vars'] <> NULL and _params['z'] <> NULL and whattype(z)=integer and _params['k'] = NULL then
		NF2Germ(ggg,vars,z)
	elif _params['ggg'] <> NULL and _params['vars'] <> NULL and _params['z'] = list and _params['k'] <> NULL and whattype(k)=integer then
		NF1Germ(ggg,vars,k)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
NF1Germ:=proc(ggg,vars,k)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	t1:=kernelopts(cputime);
	g:=ggg;
	#g:=mtaylor(ggg,[x,lambda],k+1);#subs(lambda=y,ggg);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	Sprim:=[mtaylor(vars[1]*g,vars,k),mtaylor(vars[2]*g,vars,k),mtaylor(vars[1]^2*diff(g,vars[1]),vars,k),mtaylor(vars[2]*diff(g,vars[1]),vars,k)];
	high:=Itr2(Sprim,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		return("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1Germ(S,vars,k);
	P0:={op(IT[1])};
	g:=NormalForm(mtaylor(g,vars,k+1),P0,plex(op(vars)));
	Sperp:={op(IG2Germ(g,vars,k)[-1])}; 
	Pperp:={op(NSetGerm([seq(LMGerm(f,k,vars),f=StandardBasisGerm(P0,vars,k))],vars,k))};
	A:=Pperp minus Sperp;
	C:={op(IG2Germ(g,vars,k)[2])};
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		if LeadingMonomial(g,plex(op(vars)))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		 fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			 od;
		od;
		d:=d-1;
	od;
	H:=seq(expand(subs(op(s),g)),s=[SS]);
	RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################second one
NF2Germ:=proc(ggg,vars,k)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	g:=ggg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	Sprim:=[mtaylor(vars[1]*g,vars,k),mtaylor(vars[2]*g,vars,k),mtaylor(vars[1]^2*diff(g,vars[1]),vars,k),mtaylor(vars[2]*diff(g,vars[1]),vars,k)];
	high:=Itr2(Sprim,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		return("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1Germ(S,vars,k);
	P0:={op(IT[1])};
	g:=NormalForm(mtaylor(g,vars,k+1),P0,plex(op(vars)));#I changed g into mtaylor of g;
	Sperp:={op(IG2Germ(g,vars,k)[-1])}; 
	Pperp:={op(NSetGerm([seq(LMGerm(f,k,vars),f=StandardBasisGerm(P0,vars,k))],vars,k))};
	A:=Pperp minus Sperp;
	C:={op(IG2Germ(g,vars,k)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars)));
		g:=simplify(g-LeadingCoefficient(g,plex(op(vars)))*LeadingMonomial(g,plex(op(vars))));
		if LeadingMonomial(g,plex(op(vars)))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(op(vars)));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				fi;
			 od;
		 od;
		if flag then
			d:=d-1;
		fi;
	od;
	 g:=expand(subs(ss,g));
	 RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {}
# Input:
# {  }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr1Germ:=proc(Ideal,vars,k)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	#F:=[g,lambda*diff(g,x),x*diff(g,x)];
	F:=Ideal;
	S:=StandardBasisGerm(F,vars,k);
	#LMS:=[seq(LMGerm(f,k,[x,lambda]),f=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	 # if indets(LMS[i])={x} then
	#flag:=true;
	#fi;
	#od;
	#if flag then
	#for i from 1 to nops(S) while flag do
	#if indets(LMS[i])={lambda} then
        #flag:=false;
	#fi;
	#od;
	#if flag then
	 #RETURN("The ideal is of infinite codimension.");
	#fi;
	#else
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	NEWPOINT:=NULL;
	MaxPower:=0;  
	for u in {op(vars)} do         
		M:=MultMatrixGerm(S,u,vars,k):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower, vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if DivAlgGerm(m,S,k,vars)<>0 then 
				flag:=false;
				#else         
				#RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i, vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if DivAlgGerm(m,S,k,vars)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(kk,j,vars)
	if degree(kk,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
j:=1;
ind:=MaxPower;
while MM<>{} do
	MM:=select(SelFun,M,j,vars);
	MMM:={seq(expand(m/vars[2]^j),m=MM)};
	if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
		OUT:=OUT,[0,degree(MM[1])]; 
		M:=M minus {MM[1]}; 
	else
		B:=MaxPower;
		for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
			MX:={MonomialMaker(i, vars)};
			if MX subset MMM then
				flag:=true;
				#OUT:=OUT,[i,j];
				B:=min(B,i);
				#M:=M minus {seq(lambda*mx,mx=MX)};
			fi;
		od;
		if flag and B+j < ind then
			OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		j:=j+1;
	fi;
od;
L:=[MonomialMaker([OUT][1][1], vars),seq(op(expand([MonomialMaker([OUT][i][1], vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
Y:=seq(DivAlgGerm(F[i],L,k,vars),i=1..nops(F));
M:='M';
#L:=subs(y=lambda,L);
#FF:=subs(y=lambda,F);
NN:=expand(subs(y=vars[2],{seq(DivAlgGerm(F[i],L,k,vars),i=1..nops(F))})) minus {0};
L:=subs(y=vars[2],L);
NN:={seq(NormalForm(g,L,plex(op(vars))),g=NN)};
if NN={} then
	RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
else
	RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	#RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
fi;
#RETURN(OUT);  
end: 
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {}
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
MultMatrixGerm:=proc(S,u,vars,k)
global t;
local L,n,M,i,v,j,c;
#option trace;
	L:=NSett([seq(LMGerm(f,k,vars),f=S)]);
	n:=nops(L);
	M:=Matrix(n);
	for i from 1 to n do
		v:=DivAlgGerm(u*L[i],S,k,vars);
		M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				 M[j,i]:=c;
			fi;
		od;
	od;
	RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
IG2Germ:= proc (ff, V,k) 
#option trace;
local II,M,N,T,SortFun,S,NN,NNN,C,ZC,MaxPowerOfM,MinPowerOfMl,flag,q,L,i,MM,SB,ll;
	M:='M';
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
end:
N:=sort([N],SortFun);
S := 0;
NN := 0;
NNN := 0;
C := NULL;
ZC:=NULL;
II:=NULL;
MaxPowerOfM:=0;
MinPowerOfMl:=infinity;
flag:=false;
for q in N do 
	if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
		if q[-1] <> 0 then 
			if q[1]<>0 and (not flag or q[1]+q[-1]<MaxPowerOfM) then
				NN := NN+M^q[1]*`<,>`(V[2]^q[-1]);
				NNN := NNN,V[1]^q[1]*V[2]^q[-1];
				C:=C,Diff(f,V[1]$q[1],V[2]$q[2]); 
				MinPowerOfMl:=min(MinPowerOfMl,q[1]+q[-1]);
			elif q[1]=0 and (not flag or q[1]+q[-1]<MaxPowerOfM) and (q[-1]<MinPowerOfMl) then
				NN := NN+`<,>`(V[2]^q[-1]);
				NNN := NNN,V[1]^q[1]*V[2]^q[-1];
				C:=C,Diff(f,V[1]$q[1],V[2]$q[2]);                 
			 fi;
		elif q[1]<>0 and not flag then
			NN := NN+M^q[1];
			NNN := NNN,V[1]^q[1];
			C:=C,Diff(f,V[1]$q[1]);
			MaxPowerOfM:=q[1]; 
			flag:=true;
		end if; 
		#NNN := NNN,x^q[1]*lambda^q[-1]; 
		#C := C, diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))<>0; 
		#L:=NULL;
		#for i from 1 to nops(V) do
		#    if q[i]<>0 then
		#        L:=L,seq(V[i],j=1..q[i]);
		#    fi;
		#od;
		#if L=NULL then
		#    C:=C,f<>0;
		#else
		#    C := C, Diff(f,subs(y=lambda,[L]))<>0; 
		#fi;
        if q[1]<>0 then
		MM:=[MonomialMaker(q[1], V)];
		II:=II,op(expand(V[2]^q[-1]*MM));
        elif q[2]<>0 then
		II:=II, V[2]^q[-1];
        fi;
    end if; 
end do;  
SB:=StandardBasisGerm([II],V,k);  
N:=NSetGerm([seq(LMGerm(f,k,V),f=SB)],V,k);
ll:=1;
if  1 in N then
	ZC:=f=0;
	ll:=2;
fi;
ZC:=[ZC,seq(Diff(f,V[1]$degree(v,V[1]),V[2]$degree(v,V[2]))=0,v in N[ll..-1])];
RETURN(NN, {NNN} minus {0}, C ,N); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
NSetGerm := proc (LL,vars,k) 
#option trace;
local g,L,V, d, N, v, x, m, i, j, u, flag, l; 
	L:={seq(LMGerm(f,k,vars),f=LL)};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			 N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRTT2Germ:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Germ(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([seq(LMGerm(f,k,vars),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRTT2newGerm:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Germ(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSet([seq(LMGerm(f,k,vars),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg1(h,{op(RNF),H},[vars[2],vars[1]]);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfoldingGerm:=proc(a,b,vars,c,k)
	if _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=integer and _params['vars'] <> NULL and _params['c'] = NULL and _params['k']= NULL  then
		UniversalUnfolding1Germ(a,vars,b)[1]
	elif _params['a']<>NULL and _params['b'] = list and _params['vars'] <> NULL and _params['c'] <> NULL and whattype(c)=integer and _params['k']=NULL  then
		UniversalUnfolding2Germ(a,vars,c)[1]
	elif _params['a']<>NULL and _params['b'] = normalform and _params['vars'] <> NULL and _params['c'] <> NULL and whattype(c)=integer and _params['k']=NULL then 
		UniversalUnfolding1Germ(a,vars,c)[2]
	elif _params['a']<>NULL and _params['b'] = normalform and _params['vars'] <> NULL and _params['c'] = list and _params['k'] <> NULL and whattype(k)=integer then  
		UniversalUnfolding2Germ(a,vars,k)[2]
	fi;  
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding1Germ:=proc(g,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET:=PRTT2Germ(g,vars,k);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformGerm(g,vars,k)+add(alpha[i]*ET[i],i=1..nops(ET));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfolding2Germ:=proc(g,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET1:=PRTT2Germ(g,vars,k);
	ET2:=PRTT2newGerm(g,vars,k);
	G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
	G3:=NormalformGerm(g,vars,k)+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G4:=NormalformGerm(g,vars,k)+add(alpha[i]*ET2[i],i=1..nops(ET2));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([[G1,G2],[G3,G4]]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic1Germ:=proc(L,vars,k)
#option trace;
local firsttime, firstbytes, II;
firsttime, firstbytes := kernelopts(cputime, bytesused);
	II:=Itr1Germ(L,vars,k);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic2Germ:=proc(F,V,vars,k)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	Kazemi1:=Itr1Germ(F,vars,k)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1Germ(F,vars,k)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
		od;
		a := NULL;
		for t in [mahsa] do
			a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
		od;
		L := `minus`({op(W)}, {0});
		K := add(i, i = [a]);
		 print("Intrinsic part is=",K);
            end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntrinsicGerm:=proc(U,V,vars,k)
if _params['U']<>NULL and _params['V']=NULL and _params['vars']<>NULL and _params['k']<>NULL then
	Intrinsic1Germ(U,vars,k)
elif _params['U']<>NULL and _params['V']<>NULL and _params['vars']<>NULL and _params['k']<>NULL then
	Intrinsic2Germ(U,V,vars,k)
fi;
end:    
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
SPERPGerm:= proc (ff, V,k) 
#option trace;
local N,T,SortFun,II,q,MM,SB;
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
end:
N:=sort([N],SortFun);
II:=NULL;
for q in N do 
    if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
        if q[1]<>0 then
            MM:=[MonomialMaker(q[1], V)];
            II:=II,op(expand(V[2]^q[-1]*MM));
        elif q[2]<>0 then
            II:=II, V[2]^q[-1];
        fi;
    end if; 
end do; 
SB:=StandardBasisGerm([II],V,k);
N:=NSett([seq(LMGerm(f,k,V),f=SB)],k);
return(N);
end:     
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
GermRecognitionGerm:=proc(h,vars,k)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPGerm(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	print("S=",mahh);#(h)
	#print("Nonzero condition=",[AB]);
	print("S^{⊥}=",{op(SPERPGerm(add(i,i=[op(P)]),vars,k))});#{⊥}(h)
	print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
AlgObjectsGerm:=proc(ggg,vars,k)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Germ(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(op(vars))),r=R)];
	N:=NSett([seq(LMGerm(f,k,vars),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognitionGerm(g,k,vars));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
germrecognitionGerm:=proc(h,vars,k)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPGerm(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	#print("intrinsic generators=",P);
	#print("S=",mahh);
	print("Nonzero condition=",[AB]);
	#print("SPERP=",SPERP(add(i,i=[op(P)]),[x,lambda]));
	print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRNEWGerm:=proc(ggg,vars,k)
#option trace;
local Kazemi,TT,Kazemi1,Kazemi2,Kazemi3,Kazemi4,RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Germ(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			 #print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modificationnew([Kazemi3],Kazemi4,ggg,vars);
	#print(Kazemi3,Kazemi4);
	#return([Kazemi3]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RECOGNITIONGerm:=proc(h,vars,kk)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEWGerm(h,vars,kk),vars);
	d := SPERPGerm(h, vars,kk);
	ET := PRTT2Germ(h,vars,kk);
	B := [diff(g(vars[1], vars[2]), `$`(vars[1], 1)), diff(g(vars[1], vars[2]), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(vars[1],vars[2]),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(vars[1], vars[2]),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		E := NULL;
		for hh in k do
			if hh=0 then
				E := E, hh;
			elif {op( op(0,hh))}subset {op(vars)} then
				E := E, hh;
			else
				HH := subs(g = G, hh);
				E := E, HH;
			fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RecognitionProblemGerm:=proc(f,vars,c,k)
	if _params['f'] <>NULL and  _params['vars'] <>NULL  and _params['c']<> NULL and whattype(c)=integer and _params['k']=NULL then
		germrecognitionGerm(NormalformGerm(mtaylor(f,vars,4),vars,c),vars,c)
	elif _params['f'] <>NULL and  _params['vars'] <>NULL and _params['c'] = universalunfolding and _params['k'] <>NULL and
		whattype(k)=integer then
		RECOGNITIONGerm(NormalformGerm(mtaylor(f,vars,6),vars,k),vars,k)
	end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
############################Some extra computations###################
Division:=proc(a,b,c,d,f)
if _params['a'] <> NULL and _params['b'] <> NULL and _params['c']=Fractional and _params['d']=NULL and _params['f']=NULL  then
	MoraNF(a,b)

elif _params['a'] <> NULL and _params['b'] <> NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['f']=Fractional then
	MoraNFFractionalRing(a,b,d,c)

elif _params['a'] <> NULL and _params['b'] <> NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['f']=Formal then
	DivAlgFormal(a,b,d,c)
elif _params['a'] <> NULL and _params['b'] <> NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer  and _params['f']=SmoothGerms then
	DivAlgGerm(a,b,d,c)
fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
StandardBasis:=proc(a,b,c,d)
if _params['a'] <> NULL and _params['b'] <> NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
	STD(a,b,Ds)
elif _params['a'] <> NULL and _params['b'] <>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
	STD(a,b,Ds)
elif _params['a'] <> NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL
 and whattype(c)=integer and _params['d']=Fractional then 
	STDFractionalRing(a,b,Ds,c)  
elif _params['a'] <> NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then 
	STDFractionalRing(a,b,Ds,c)  
elif _params['a'] <> NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL  and whattype(c)=integer and _params['d']=Formal then
	StandardBasisFormal(a,b,c)
elif _params['a'] <> NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL  and whattype(c)=integer and _params['d']=SmoothGerms  then
	StandardBasisGerm(a,b,c)
fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verify:=proc(g,N,W,K)
if _params['g'] <> NULL and _params['N'] <> NULL and whattype(N)=list and _params['W'] = NULL and _params['K'] = NULL then
	Verifydefault(g,N)
elif _params['g'] <> NULL and _params['N'] <> NULL and whattype(N)=list and _params['W'] <> NULL and whattype(W)=integer and _params['K'] = NULL then
	Verifyuser(g,N,W)
elif  _params['g'] <> NULL and whattype(g)=list and _params['N']<>NULL and whattype(N)=list and _params['W']=Ideal and _params['K'] = NULL then
	Verifydefault1(g,N)
elif  _params['g'] <> NULL and whattype(g)=list and _params['N']<>NULL and whattype(N)=list and _params['W']<>NULL and whattype(W)=integer and _params['K']=Ideal then
	Verifyuser1(g,W,N) 
 elif  _params['g'] <> NULL and whattype(g)=`+` and _params['N']<>NULL and whattype(N)=list and _params['W']=Persistent and _params['K']=NULL then
	Verifydefault1Special(g,N)
 elif  _params['g'] <> NULL and whattype(g)=`+` and _params['N']<>NULL and whattype(N)=list and _params['W']<>NULL and whattype(W)=integer and _params['K']=Persistent then
	Verifyuser1Special(g,N,W)
elif _params['g'] <> NULL and _params['N'] <> NULL and whattype(N)=list and _params['W'] <> NULL and _params['K'] = NULL then
        Verifyuser_at_non_origin(g, N, rhs(W))
elif _params['g'] <> NULL and _params['N'] <> NULL and whattype(N)=list and _params['W'] <> NULL and _params['K'] =Persistent  then
        Verifypersistent_at_non_origin(g,N,rhs(W));
fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verifydefault:=proc(g,vars)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,Q;
global var, t;
	FLAG:=false;
	for i from 1 to 20 while FLAG=false do
		h:=mtaylor(g,vars,i+1);
		S:=[vars[1]*h,vars[2]*h,vars[1]^2*diff(h,vars[1]),vars[2]*diff(h,vars[1])];
		Q:=Basis(S,plex(op(vars)));
		P:=[Itr1(S,vars)][1];
		flag:=false;
		if P="The ideal is of infinite codimension." then
			flag:=true;
		fi;
		for j from 1 to i+1 while flag=false do 
			A:=[MonomialMaker(j, vars)];
			B:={seq(MoraNF(z,P),z in A)};
			if B={0} then
				flag:=true;
				FLAG:=true;
			fi;
		od;
	od;
	C:=[MonomialMaker(j-1, vars)];
	DD:={seq(NormalForm(z,Q,plex(op(vars))),z in C)};
	if DD={0} then
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s: \n", Ring,of,polynomial,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);#j-2
		printf(" %1s %1s %1s: \n", Recommended,rings,are);
		printf(" %1s %1s: \n", Fractional,ring);
		printf(" %1s %1s: \n", Polynomial,ring);
	else
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);#j-2
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verifydefault1:=proc(L,vars)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,x,lambda,Q;
global var, t;
	#x:=W[1];
	#lambda:=W[2];
	FLAG:=false;
	for i from 1 to 20 while FLAG=false do
		S:=[seq(mtaylor(z,vars,i+1),z=L)];
		Q:=Basis(S,plex(op(vars)));
		P:=[Itr1(S,vars)][1];
		flag:=false;
		if P="The ideal is of infinite codimension." then
			flag:=true;
		fi;
		for j from 1 to i+1 while flag=false do
			A:=[MonomialMaker(j, vars)];
			B:={seq(MoraNF(z,P),z in A)};
			if B={0} then
				flag:=true;
				FLAG:=true;
			fi;
		od;
	od;
	C:=[MonomialMaker(j-1,vars)];
	DD:={seq(NormalForm(z,Q,plex(op(vars))),z in C)};
	if DD={0} then
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s: \n", Ring,of,polynomial,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);
		printf(" %1s %1s %1s: \n", Recommended,rings,are);
		printf(" %1s %1s: \n", Fractional,ring);
		printf(" %1s %1s: \n", Polynomial,ring);
	else
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################################parametric G W is a list of all vars staring with x and lambda?####
Verifydefault1Special:=proc(G,vars)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,BB,FirstNum,H,ay,jey,SeconNum,DE,t,Jey,ThirdNum;
	B:=[G,diff(G,vars[1]),diff(G,vars[2])];
	FLAG:=false;
	for i from 1 to 20 while FLAG=false do
		S:=[seq(mtaylor(z,vars,i+1),z=B)];
		P:=Basis(S,plex(op(vars)));
		for j from 1 to i+1 do
			A:=[MonomialMakerSpecial(j,vars)];
			BB:={seq(NormalForm(z,P,plex(op(vars))),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	FirstNum:=j-2;
	H:=[G,diff(G,vars[1]),diff(G,vars[1]$2)];
	FLAG:=false;
	for ay from 1 to 20 while FLAG=false do
		S:=[seq(mtaylor(z,vars,ay+1),z=H)];
		P:=Basis(S,plex(op(vars)));
		for jey from 1 to ay+1 do
			A:=[MonomialMakerSpecial(jey,vars)];
			BB:={seq(NormalForm(z,P,plex(op(vars))),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	SeconNum:=jey-2;
	DE:=[G,diff(G,vars[1]), subs(vars[1]=xx,G), subs(vars[1]=xx,diff(G,vars[1]))];
	FLAG:=false;
	for t from 1 to 20 while FLAG=false do
		S:=[seq(mtaylor(z,[op(vars),xx],t+1),z=DE),1-zeta*(vars[1]-xx)];
		P:=Basis(S,plex(op(vars),xx,zeta));
		for Jey from 1 to t+1 do
			A:=[MonomialMakerSpecial(Jey,[op(vars),xx])];
			BB:={seq(NormalForm(z,P,plex(op(vars),xx,zeta)),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	ThirdNum:=Jey-2;
	return(max(FirstNum,SeconNum,ThirdNum));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verifyuser1Special:=proc(G,vars,N)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,BB,FirstNum,H,SeconNum,DE,ThirdNum;
	B:=[G,diff(G,vars[1]),diff(G,vars[2])];
	FLAG:=false;
	for i from 1 to N while FLAG=false do
		S:=[seq(mtaylor(z,vars,i+1),z=B)];
		P:=Basis(S,plex(op(vars)));
		for j from 1 to i+1 do
			A:=[MonomialMakerSpecial(j,vars)];
			BB:={seq(NormalForm(z,P,plex(op(vars))),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	FirstNum:=j-2;
	H:=[G,diff(G,vars[1]),diff(G,vars[1]$2)];
	FLAG:=false;
	for i from 1 to N while FLAG=false do
		S:=[seq(mtaylor(z,vars,i+1),z=H)];
		P:=Basis(S,plex(op(vars)));
		for j from 1 to i do
			A:=[MonomialMakerSpecial(j,vars)];
			BB:={seq(NormalForm(z,P,plex(op(vars))),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	SeconNum:=j-2;
	DE:=[G,diff(G,vars[1]), subs(vars[1]=xx,G), subs(vars[1]=xx,diff(G,vars[1]))];
	FLAG:=false;
	for i from 1 to N while FLAG=false do
		S:=[seq(mtaylor(z,[op(vars),xx],i+1),z=DE),1-zeta*(vars[1]-xx)];
		P:=Basis(S,plex(op(vars),xx,zeta));
		for j from 1 to i do
			A:=[MonomialMakerSpecial(j,[op(vars),xx])];
			BB:={seq(NormalForm(z,P,plex(op(vars),xx,zeta)),z in A)};
			if BB={0} then
				FLAG:=true;
			fi;
		od;
	od;
	ThirdNum:=j-2;
	return(max(FirstNum,SeconNum,ThirdNum));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verifyuser_at_non_origin := proc(g,vars,point_in)
local ggg:
      ggg := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],g);
      return(Verifydefault(ggg, [X,Y]));	 
end proc:

Verifypersistent_at_non_origin := proc(g,vars, point_in)
local ggg:
      ggg := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],g);
      return(Verifydefault1Special(ggg, [X,Y]));
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
# Note :
# {On Jan31, 2018 we have noticed that we needed to increase the trunction degree by 1 for Verifydefault but for Verifyuser I hitted something# the truncation degree is 4 but when I enter 3 it does not give me an error to increase the number. }
#>-----------------------------------------------------------------------------
Verifyuser:=proc(g,vars,N)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,Q;
global var, t;
	FLAG:=false;
	for i from 1 to N while FLAG=false do
		h:=mtaylor(g,vars,i+1);
		S:=[vars[1]*h,vars[2]*h,vars[1]^2*diff(h,vars[1]),vars[2]*diff(h,vars[1])];
		Q:=Basis(S,plex(op(vars)));
		P:=[Itr1(S,vars)][1];
		flag:=false;
		if P="The ideal is of infinite codimension." then
			flag:=true;
		fi;
		for j from 1 to i+1 while flag=false do
			A:=[MonomialMaker(j,vars)];
			B:={seq(MoraNF(z,P),z in A)};
			if B={0} then
				flag:=true;
				FLAG:=true;
			fi;
		od;
	od;
	if B<>{0} then
		return("Increase the upper bound for the truncation degree!")
	fi;
	C:=[MonomialMaker(j-1,vars)];
	DD:={seq(NormalForm(z,Q,plex(op(vars))),z in C)};
	if DD={0} then
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s: \n", Ring,of,polynomial,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-2);
		printf(" %1s %1s %1s: \n", Recommended,rings,are);
		printf(" %1s %1s: \n", Fractional,ring);
		printf(" %1s %1s: \n", Polynomial,ring);
	else
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-2);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verifyuser1:=proc(L,N,vars)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,x,lambda,Q;
global var, t;
	#x:=W[1];
	#lambda:=W[2];
	FLAG:=false;
	for i from 4 to N while FLAG=false do
		S:=[seq(mtaylor(z,vars,i+1),z=L)];
		Q:=Basis(S,plex(op(vars)));
		P:=[Itr1(S,vars)][1];
		flag:=false;
		if P="The ideal is of infinite codimension." then
			flag:=true;
		fi;
		for j from 1 to i+1 while flag=false do
			A:=[MonomialMaker(j,vars)];
			B:={seq(MoraNF(z,P),z in A)};
			if B={0} then
				flag:=true;
				FLAG:=true;
			fi;
		od;
	od;
	if B<>{0} then
		return("Increase the upper bound for the truncation degree!");
	fi;
	C:=[MonomialMaker(j-1,vars)];
	DD:={seq(NormalForm(z,Q,plex(op(vars))),z in C)};
	if DD={0} then
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s: \n", Ring,of,polynomial,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);
		printf(" %1s %1s %1s: \n", Recommended,rings,are);
		printf(" %1s %1s: \n", Fractional,ring);
		printf(" %1s %1s: \n", Polynomial,ring);
	else
		printf("%1s %1s %1s %1s %1s %1s %1s %1s %1s:\n",The,following,rings,are,allowed,as,means,of,computations):
		printf(" %1s %1s %1s %1s: \n", Ring,of,smooth,germs);
		printf(" %1s %1s %1s %1s %1s: \n", Ring,of,formal,power,series);
		printf(" %1s %1s %1s %1s: \n", Ring,of,fractional,germs);
		printf(" %1s %1s %1s %1s %1s:%1a \n", The,truncated,degree,must,be,j-1);
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#InfCodim:=proc(L,N)
#option trace;
#local F, S, O, i, flag, j;
#F:=[seq(mtaylor(f,[x,lambda],N+1),f=L)];
#S:=[op({op(STD(F,[x,lambda],Ds))} minus {0})];
#q[0]:=NULL;
#for i from 1 to N do 
#flag:=false;
#q[i]:=NULL;                   
# for j from i-1 to 0 by -1 while flag=false do
# if {seq(MoraNF(g*lambda^(i-j),S),g=[MonomialMaker(j, vars)])}={0} then 
#if nops([seq(q[t],t=0..i-1)])=0 then
#q[i]:=q[i],[M^(j)*<lambda^(i-j)>,i-j];
# elif nops([seq(q[t],t=0..i-1)])<>0 then
#if i-j < [seq(q[t],t=0..i-1)][-1][2] then
#q[i]:=q[i],[M^(j)*<lambda^(i-j)>,i-j];  
#else
#flag:=true;
# fi;
# fi;
#fi;
#od;
#od;
#Q:={seq([q[i]],i=1..N)} minus {[]};
#add(s[-1][1],s=Q);
#end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################################################
INF1Fractional:=proc(Z,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, z, A, ES, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	FF:=[FF[1],vars[1]*diff(FF[1],vars[1]),vars[2]*diff(FF[1],vars[1])];
	S:=[op({op(STD(FF,vars,Ds))} minus {0})];
	#S:=STD(Z,[x,lambda],Ds);
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if MoraNF(m,S)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
j:=1;
ind:=MaxPower;
while MMM<>{} do
	MMM:=select(SelFun,MM,j,vars);
	MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
	if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
		OUT:=OUT,[0,degree(MMM[1])]; 
		MM:=MM minus {MMM[1]}; 
	else
		B:=MaxPower;
		for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
			MX:={MonomialMaker(i,vars)};
			if MX subset MMMM then
				flag:=true;
				#OUT:=OUT,[i,j];
				B:=min(B,i);
				#M:=M minus {seq(lambda*mx,mx=MX)};
			fi;
		od;
		if flag and B+j < ind then
			OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		if j<MaxPower then
			j:=j+1;
		else
			 # return(OUT);
			if nops([OUT])=1 then
				A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
			else
				ES:=STD([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,Ds);
				A:={seq(MoraNF(simplify(f-mtaylor(f,vars,MaxPower+1)),ES),f=Z)};
			fi;
			if A={0} then
				INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
				return("Intrinsic part is"=INS);
			else
				return("Computations are correct modulo terms of degrees higher and equal to 20");
			fi;
			#return(OUT);
		fi;
	fi;
od;
if nops([OUT])=0 then
return("no intrinsic part");
fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2Fractional:=proc(Z,MaxPower,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, um, ES, A, INS;
	um:=MaxPower;
	OUT:=NULL;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	FF:=[FF[1],vars[1]*diff(FF[1],vars[1]),vars[2]*diff(FF[1],vars[1])];
	S:=[op({op(STD(FF,vars,Ds))} minus {0})];
	#S:=STD(Z,[x,lambda],Ds);
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if MoraNF(m,S)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
j:=1;
ind:=MaxPower;
while MMM<>{} do
	MMM:=select(SelFun,MM,j,vars);
	MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
	if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
		OUT:=OUT,[0,degree(MMM[1])]; 
		MM:=MM minus {MMM[1]}; 
	else 
		B:=MaxPower;
		for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
			MX:={MonomialMaker(i,vars)};
			if MX subset MMMM then
				flag:=true;
				#OUT:=OUT,[i,j];
				B:=min(B,i);
				#M:=M minus {seq(lambda*mx,mx=MX)};
			fi;
		od;
		if flag and B+j < ind then 
			OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		if j<MaxPower then
			j:=j+1;
		else 
			#return(OUT);
			if nops([OUT])=1 then
				A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2]);
			else
				ES:=STD([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,Ds);
				A:={seq(MoraNF(simplify(f-mtaylor(f,vars,MaxPower+1)),ES),f=Z)};
			fi;
			if A={0} then
				INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
				return("Intrinsic part is=",INS);
			else
				return("Computations are correct modulo terms of degrees higher and equal to =",um);
			fi;
		fi;
	fi;
od;
if nops([OUT])=0 then
return("no intrinsic part");
fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF1Germ:=proc(Z,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(StandardBasisGerm(FF,vars,20))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if DivAlgGerm(m,S,20,vars)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
		if degree(k,vars[2]) >= j then
			RETURN(true);
		fi;
		RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				 MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
		if flag and B+j < ind then
			OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		if j<MaxPower then
			j:=j+1;
		else
			#return(OUT);
			if nops([OUT])=1 then
				A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2]);
			else
         
				ES:=StandardBasisGerm([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])], vars,20);
				A:={seq(DivAlgGerm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,20,vars),f=Z)};
			fi;
			if A={0} then
				INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
				return("Intrinsic part is=",INS);
			else
				return("Computations are correct modulo terms of degrees higher and equal to =",50);
			fi;
		fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2Germ:=proc(Z,MaxPower,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(StandardBasisGerm(FF,vars,MaxPower))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if DivAlgGerm(m,S,MaxPower,vars)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
end:
j:=1;
ind:=MaxPower;
while MMM<>{} do
	MMM:=select(SelFun,MM,j,vars);
	MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
	if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
		OUT:=OUT,[0,degree(MMM[1])]; 
		MM:=MM minus {MMM[1]}; 
	else
		B:=MaxPower;
		for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
			MX:={MonomialMaker(i,vars)};
			if MX subset MMMM then
				flag:=true;
				#OUT:=OUT,[i,j];
				B:=min(B,i);
				#M:=M minus {seq(lambda*mx,mx=MX)};
			fi;
		od;
		if flag and B+j < ind then
			 OUT:=OUT,[B,j];
			ind:=B+j;
		fi;
		if j<MaxPower then
			j:=j+1;
		else
			#return(OUT);
			if nops([OUT])=1 then
				A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2]);
			else
				ES:=StandardBasisGerm([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,MaxPower);
				A:={seq(DivAlgGerm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,MaxPower,vars),f=Z)};
			fi;
			if A={0} then
				INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
				return("Intrinsic part is=",INS);
			else
				return("Computations are correct modulo terms of degrees higher and equal to =",50);
			fi;
		fi;
	fi;
od;
if nops([OUT])=0 then
	return("no intrinsic part");
fi; 
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
InfCodim:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL  then
		INF1Fractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then
		INF2Fractional(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=SmoothGerms and _params['d']=NULL then
		INF1Germ(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=SmoothGerms then
		INF2Germ(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
CodimDetect:=proc(L,X,V,W)
	if Itr1(L)="The ideal is of infinite codimension." then
		print("This is an infinit codimensional ideal");
		if _params['L']<>NULL and _params['X']<>NULL and whattype(X)=list and _params['V']=Fractional and _params['W']=NULL then
			INF1Fractional(L,X)
		elif _params['L']<>NULL and _params['X']<>NULL and whattype(X)=list and _params['V']<>NULL and whattype(V)=integer and _params['W']=Fractional then
			INF2Fractional(L,V,X)
		elif _params['L']<>NULL and _params['X']<>NULL and whattype(X)=list and _params['V']=SmoothGerms and _params['W']=NULL then
			INF1Germ(L,X)
		elif _params['L']<>NULL and _params['X']<>NULL and whattype(X)=list and _params['V']<>NULL and whattype(V)=integer and _params['W']=SmoothGerms then
			INF2Germ(L,V,X)
		fi;
	else
		print("This is a finit codimensional ideal");
		return(IntrinsicFractional(L));
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
AReplace:=proc(f,N,t,vars)
#option trace;
local A,m,n,B;
	A:=NULL;
	for m from 0 to N do
		for n from 0 to N while m+n<=N do
			A := A,eval(subs([vars[1]=0,vars[2]=0],diff(f,[vars[1]$m, vars[2]$n])));
		od;
	od;
	B:=subs(vars[2]=0,[seq(diff(f,vars[2]$i),i=1..t-1)]);
	return({A,op(B)});
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Normalform:=proc(a,b,c,d,w)

	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL and _params['w']=NULL then 
		NF2PolynomialRing(a,b)  
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list and _params['d']=Polynomial and _params['w']=NULL then 
		NF1PolynomialRing(a,b)  
	elif _params['a']<>NULL and  _params['b']<>NULL and whattype(b)=list  and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial and _params['w']=NULL then     
		NF2Polynomial(a,c,b)         
	elif _params['a']<>NULL and  _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list and _params['w']=Polynomial then            
		NF1Polynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL and _params['w']=NULL then 
		NF2FractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional and _params['w']=NULL then 
		NF2FractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list  and _params['c']<>NULL and whattype(c)=integer and  _params['d']=list  and _params['w']=NULL then 
		NF1FractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list  and _params['w']=Fractional then 
		NF1FractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list  and _params['c']=NULL and _params['d']=NULL and _params['w']=NULL then 
		NF2(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list  and _params['c']=Fractional and _params['d']=NULL and _params['w']=NULL then
		NF2(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list   and _params['d']=NULL and _params['w']=NULL then
		NF1(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list and _params['d']=Fractional  and _params['w']=NULL then
		NF1(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and  _params['c']<>NULL and whattype(c)=integer and _params['d']= Formal and _params['w']=NULL then
		NF2Formal(a,b,c)
	elif _params['a']<>NULL and _params['b']<> NULL and whattype(b)=list and _params['c']<> NULL and whattype(c)=integer and _params['d']=list and _params['w']=Formal then
		NF1Formal(a,b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']= SmoothGerms and _params['w']=NULL then
		NF2Germ(a,b,c)
	elif _params['a']<>NULL and _params['b']<> NULL and whattype(b)=list and _params['c']<> NULL and whattype(c)=integer and _params['d']=list  and _params['w']=SmoothGerms then
		NF1Germ(a,b,c)
        elif _params['a']<>NULL and  _params['b']<>NULL and whattype(b)=list  and _params['c']<>NULL and whattype(c)=integer and _params['d']<>NULL  and _params['w']=NULL then 
               NF_at_non_zero_point(a,c,b,rhs(d))
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding := proc()
local a_in, b_in:
	if evalb(nargs=7 and lhs(args[7])='SingularPoint') then 
		a_in := subs([args[2][1]=X+rhs(args[7])[1], args[2][2]=Y+rhs(args[7])[2]],args[1]);
		b_in := UniversalUnfolding_before(a_in,[X,Y],args[3],args[4],args[5],args[6]);
		return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=6 and type(args[6],`=`) and lhs(args[6])='SingularPoint') then
		a_in := subs([args[2][1]=X+rhs(args[6])[1], args[2][2]=Y+rhs(args[6])[2]],args[1]);
		b_in := UniversalUnfolding_before(a_in,[X,Y],args[3],args[4],args[5]);	
		return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif evalb(nargs=6) then
		UniversalUnfolding_before(args[1],args[2],args[3],args[4],args[5],args[6]);	
	elif  evalb(nargs=5 and type(args[5],`=`) and lhs(args[5])='SingularPoint') then 
		a_in := subs([args[2][1]=X+rhs(args[5])[1], args[2][2]=Y+rhs(args[5])[2]],args[1]);
		b_in := UniversalUnfolding_before(a_in,[X,Y],args[3],args[4]);	
		return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=5) then
		UniversalUnfolding_before(args[1],args[2],args[3],args[4],args[5]);
	elif  evalb(nargs=4 and type(args[4],`=`) and lhs(args[4])='SingularPoint') then 
		a_in := subs([args[2][1]=X+rhs(args[4])[1], args[2][2]=Y+rhs(args[4])[2]],args[1]);
		b_in := UniversalUnfolding_before(a_in,[X,Y],args[3]);
		return(subs([X=args[2][1],Y=args[2][2]],b_in));		
	elif  evalb(nargs=4) then
		UniversalUnfolding_before(args[1],args[2],args[3],args[4]);
	elif  evalb(nargs=3 and type(args[3],`=`) and lhs(args[3])='SingularPoint') then
		 a_in := subs([args[2][1]=X+rhs(args[3])[1], args[2][2]=Y+rhs(args[3])[2]],args[1]);
		 b_in := UniversalUnfolding_before(a_in,[X,Y]);
		 return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=3) then
		UniversalUnfolding_before(args[1],args[2],args[3]);
	elif  evalb(nargs=2) then
		UniversalUnfolding_before(args[1],args[2]);
	end if:
	
end proc:
#>-----------------------------------------------------------------------------
UniversalUnfolding_before:=proc(a,b,c,d,v,p)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL and _params['v']=NULL and _params['p']=NULL then
		 UniversalUnfolding1PolynomialRing(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list and _params['d']=Polynomial and _params['v']=NULL and _params['p']=NULL then    
		UniversalUnfolding2PolynomialRing(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=Polynomial and _params['v']=NULL and _params['p']=NULL then     
		UniversalUnfolding1PolynomialRing(a,b)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=list and _params['v']=Polynomial and _params['p']=NULL then     
		UniversalUnfolding2PolynomialRing(a,b)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and  whattype(c)=integer  and _params['d']=Polynomial and _params['v']=NULL and _params['p']=NULL then
		UniversalUnfolding1Polynomial(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list  and _params['v']=Polynomial and _params['p']=NULL then
		UniversalUnfolding2Polynomial(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform  and _params['v']=Polynomial and _params['p']=NULL then
		UniversalUnfolding1Polynomial(a,b,c)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=list  and _params['p']=Polynomial then 
		if whattype(UniversalUnfolding2Polynomial(a,b,c))<>list then
			return (op([]));
		else
			UniversalUnfolding2Polynomial(a,b,c)[2]  
		end if:   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL and _params['v']=NULL and _params['p']=NULL  then
		UniversalUnfolding1FractionalRing(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional and _params['v']=NULL and _params['p']=NULL then     
		UniversalUnfolding1FractionalRing(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list and _params['v']=NULL and _params['p']=NULL  then  
		UniversalUnfolding2FractionalRing(a,b,c)[1]
	elif _params['a']<>NULL  and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list and _params['v']=Fractional and _params['p']=NULL then  
		UniversalUnfolding2FractionalRing(a,b,c)[1]        
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and  _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=NULL and _params['p']=NULL then 
		UniversalUnfolding1FractionalRing(a,b,c)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=Fractional and _params['p']=NULL then 
		UniversalUnfolding1FractionalRing(a,b,c)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and  _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=list  and _params['p']=NULL  then 
		UniversalUnfolding2FractionalRing(a,b,c)[2]  
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=list  and _params['p']=Fractional  then 
		UniversalUnfolding2FractionalRing(a,b,c)[2]     
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL and
 _params['v']=NULL and _params['p']=NULL  then
		UniversalUnfolding1(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL and _params['v']=NULL and _params['p']=NULL then
		 UniversalUnfolding1(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list and _params['d']=NULL and
 _params['v']=NULL and _params['p']=NULL then
		UniversalUnfolding2(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=list and _params['d']=Fractional and _params['v']=NULL and _params['p']=NULL then
		UniversalUnfolding2(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=NULL and _params['v']=NULL and _params['p']=NULL then
		UniversalUnfolding1(a,b)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=Fractional and _params['v']=NULL and _params['p']=NULL then
		UniversalUnfolding1(a,b)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=list and _params['v']=NULL and _params['p']=NULL then  
		UniversalUnfolding2(a,b)[2] 
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=normalform and _params['d']=list and _params['v']=Fractional and _params['p']=NULL then  
		UniversalUnfolding2(a,b)[2]  
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal and _params['v']=NULL and _params['p']=NULL then 
		UniversalUnfolding1Formal(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list  and _params['v']=Formal and _params['p']=NULL then  
		UniversalUnfolding2Formal(a,b,c)[1]     
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform  and _params['v']=Formal and _params['p']=NULL then 
		UniversalUnfolding1Formal(a,b,c)[2]   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=list and _params['p']=Formal then 
		UniversalUnfolding2Formal(a,b,c)[2] 
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms and _params['v']=NULL and _params['p']=NULL  then 
		UniversalUnfolding1Germ(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=list  and _params['v']=SmoothGerms and _params['p']=NULL then  
		UniversalUnfolding2Germ(a,b,c)[1]     
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform  and _params['v']=SmoothGerms and _params['p']=NULL then 
		UniversalUnfolding1Germ(a,b,c)[2]   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['v']=list  and _params['p']=SmoothGerms  then 
		UniversalUnfolding2Germ(a,b,c)[2] 
	fi;     
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################################I modify this for maplesoft
Intrinsic:=proc(a,b,c,d,f,g)
	if Itr1(a,b)="The ideal is of infinite codimension." then 
		#if nargs =3 then
		#if _params['a']<>NULL and _params['b']=Fractional and _params['c']=InfCodim and _params['d']=NULL and _params['f']=NULL then 
			#INF1Fractional(a,b)
		if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=InfCodim and _params['d']=Fractional and 
_params['f']=NULL and _params['g']=NULL  then
			INF1Fractional(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=InfCodim  and _params['f']=NULL and _params['g']=NULL  then
			INF1Polynomial(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional and _params['f']=InfCodim and _params['g']=NULL  then
			INF2Fractional(a,c,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=InfCodim  and _params['f']=NULL and _params['g']=NULL then
			INF2Fractional(a,c,b) 
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=Polynomial and _params['f']=InfCodim and _params['g']=NULL then
			INF2Polynomial(a,c,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list  and _params['c']=SmoothGerms  and _params['d']=InfCodim and _params['f']=NULL  and _params['g']=NULL then
			INF1Germ(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=SmoothGerms  and _params['f']=InfCodim and _params['g']=NULL then
			INF2Germ(a,c,b)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']=InfCodim  and _params['f']=NULL  and _params['g']=NULL  then
			INF1Frac(a,b,c)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']=Fractional and _params['f']=InfCodim  and _params['g']=NULL  then
			INF1Frac(a,b,c)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and  whattype(d)=integer  and _params['f']=Fractional  and _params['g']=InfCodim then  
			INF2Frac(a,d,b,c)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and  whattype(d)=integer  and _params['f']=InfCodim  and _params['g']=NULL  then  
			INF2Frac(a,d,b,c)    
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(b)=list and _params['d']=SmoothGerms and _params['f']=InfCodim  and _params['g']=NULL  then
			INF1Ge(a,b,c)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer  and _params['f']=SmoothGerms and _params['g']=InfCodim then
			INF2Ge(a,d,b,c)  
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']=Polynomial  and _params['f']=InfCodim  and _params['g']=NULL then
			INF1Pol(a,b,c)
		elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['f']=Polynomial and _params['g']=InfCodim  then
			INF2Pol(a,d,b,c) 
		fi;    
	else
		if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL  and _params['f']=NULL and _params['g']=NULL then
			Intrinsic1(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL  and _params['f']=NULL and _params['g']=NULL then
			Intrinsic1(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=NULL  and _params['f']=NULL and _params['g']=NULL then  
			Intrinsic1FractionalRing(a,c,b)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional  and _params['f']=NULL and _params['g']=NULL then  
			Intrinsic1FractionalRing(a,c,b) 
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']=NULL  and _params['f']=NULL  and _params['g']=NULL then
			Intrinsic2(a,b,c)
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']=Fractional  and _params['f']=NULL  and _params['g']=NULL then
			Intrinsic2(a,b,c) 
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer  and _params['f']=NULL  and _params['g']=NULL then
			Intrinsic2FractionalRing(a,b,d,c) 
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer  and _params['f']=Fractional  and _params['g']=NULL then 
			Intrinsic2FractionalRing(a,b,d,c) 
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal and _params['f']=NULL and _params['g']=NULL then
			Intrinsic1Formal(a,b,c)
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['f']=Formal and _params['g']=NULL then
			Intrinsic2Formal(a,b,c,d)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer  and _params['d']=SmoothGerms  and _params['f']=NULL and _params['g']=NULL then
			Intrinsic1Germ(a,b,c)
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and  whattype(d)=integer  and _params['f']=SmoothGerms  and _params['g']=NULL then
			Intrinsic2Germ(a,b,c,d)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial  and _params['f']=NULL  and _params['g']=NULL then
			Intrinsic1Polynomial(a,c,b)
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and  whattype(d)=integer  and _params['f']=Polynomial  and _params['g']=NULL then
			Intrinsic2Polynomial(a,b,d,c)
		elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL  and _params['f']=NULL  and _params['g']=NULL then
			Intrinsic1PolynomialRing(a,b)
		elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']=Polynomial  and _params['f']=NULL  and _params['g']=NULL then
			 Intrinsic2PolynomialRing(a,b,c)
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
AlgObjects:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		AlgObjectsFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		AlgObjectsFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		AlgObjectsFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		AlgObjectsFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and  whattype(c)=integer and _params['d']=Polynomial then
		AlgObjectsPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		AlgObjectsPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		AlgObjectsFormal(a,b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		AlgObjectsGerm(a,b,c)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RecognitionProblem := proc()
local a_in, b_in:
	if evalb(nargs=7 and lhs(args[7])='SingularPoint') then 
		a_in := subs([args[2][1]=x+rhs(args[7])[1], args[2][2]=lambda+rhs(args[7])[2]],args[1]);
		b_in := RecognitionProblem_before(a_in,[x,lambda],args[3],args[4],args[5],args[6]);
		#return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=6 and type(args[6],`=`) and lhs(args[6])='SingularPoint') then
		a_in := subs([args[2][1]=x+rhs(args[6])[1], args[2][2]=lambda+rhs(args[6])[2]],args[1]);
		b_in := RecognitionProblem_before(a_in,[x,lambda],args[3],args[4],args[5]);	
		#return(subs([x=args[2][1],lambda=args[2][2]],b_in));	
	elif evalb(nargs=6) then
		RecognitionProblem_before(args[1],args[2],args[3],args[4],args[5],args[6]);	
	elif  evalb(nargs=5 and type(args[5],`=`) and lhs(args[5])='SingularPoint') then 
		a_in := subs([args[2][1]=x+rhs(args[5])[1], args[2][2]=lambda+rhs(args[5])[2]],args[1]);
		b_in := RecognitionProblem_before(a_in,[x,lambda],args[3],args[4]);	
		#return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=5) then
		RecognitionProblem_before(args[1],args[2],args[3],args[4],args[5]);
	elif  evalb(nargs=4 and type(args[4],`=`) and lhs(args[4])='SingularPoint') then 
		a_in := subs([args[2][1]=x+rhs(args[4])[1], args[2][2]=lambda+rhs(args[4])[2]],args[1]);
		b_in := RecognitionProblem_before(a_in,[x,lambda],args[3]);
		#return(subs([X=args[2][1],Y=args[2][2]],b_in));		
	elif  evalb(nargs=4) then
		RecognitionProblem_before(args[1],args[2],args[3],args[4]);
	elif  evalb(nargs=3 and type(args[3],`=`) and lhs(args[3])='SingularPoint') then
		 a_in := subs([args[2][1]=x+rhs(args[3])[1], args[2][2]=lambda+rhs(args[3])[2]],args[1]);
		 b_in := UniversalUnfolding_before(a_in,[x,lambda]);
		 #return(subs([X=args[2][1],Y=args[2][2]],b_in));	
	elif  evalb(nargs=3) then
		RecognitionProblem_before(args[1],args[2],args[3]);
	elif  evalb(nargs=2) then
		RecognitionProblem_before(args[1],args[2]);
	end if:
	
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RecognitionProblem_before:=proc(a,b,c,d,q,q_in)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL and _params['q']=NULL and _params['q_in']=NULL then
		germrecognition(NormalformFractional(a,b),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL and _params['q']=NULL and _params['q_in']=NULL then
		germrecognition(NormalformFractional(a,b),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=UniversalUnfolding and _params['d']=NULL and _params['q']=NULL and _params['q_in']=NULL then
		RECOGNITION(NormalformFractional(a,b),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=UniversalUnfolding and _params['d']=Fractional and _params['q']=NULL and _params['q_in']=NULL then
		RECOGNITION(NormalformFractional(a,b),b)
	elif params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=UniversalUnfolding and _params['d']=Fractional and _params['q']=subs and _params['q_in']=NULL then
		RECOGNITION_subs(NormalformFractional(a,b),b)
	elif  params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=UniversalUnfolding and _params['q']=Fractional and _params['q_in']=subs then
		RECOGNITION_subs(NF1FractionalRing(a,c,b),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL and _params['q']=NULL and _params['q_in']=NULL then         
		germrecognitionPolynomialRing(NormalformPolynomialRing(a,b),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=UniversalUnfolding and _params['d']=Polynomial and _params['q']=NULL and _params['q_in']=NULL then 
		RECOGNITIONPolynomialRing(NormalformPolynomialRing(a,b),b)    
	 elif _params['a'] <>NULL and _params['b']<> NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial and _params['q']=NULL and _params['q_in']=NULL then
		germrecognitionPolynomial(NormalformPolynomial(a,b,c),c,b)
	 elif _params['a'] <>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <>NULL and
  whattype(c)=integer and _params['d']=UniversalUnfolding and _params['q']=Polynomial and _params['q_in']=NULL then
		RECOGNITIONPolynomial(NormalformPolynomial(a,b,c),c,b)
	elif _params['a']<>NULL and _params['b'] <>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional and _params['q']=NULL and _params['q_in']=NULL then
		germrecognition(NormalformFractionalRing(a,b,c),b)
	elif _params['a']<>NULL and _params['b'] <>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL and _params['q']=NULL and _params['q_in']=NULL then
		germrecognition(NormalformFractionalRing(a,b,c),b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and  _params['d']=UniversalUnfolding and _params['q']=NULL and _params['q_in']=NULL then
		RECOGNITION(NormalformFractionalRing(a,b,c),b) 
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and  _params['d']=UniversalUnfolding and _params['q']=Fractional and _params['q_in']=NULL then
		RECOGNITION(NormalformFractionalRing(a,b,c),b)        
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal and _params['q']=NULL and _params['q_in']=NULL then   
		germrecognitionFormal(NormalformFormal(mtaylor(a,b,c),b,c),b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=UniversalUnfolding and _params['q']=Formal and _params['q_in']=NULL then      
		RECOGNITIONFormal(NormalformFormal(mtaylor(a,b,c),b,c),b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms and _params['q']=NULL and _params['q_in']=NULL then   
		germrecognitionGerm(NormalformGerm(mtaylor(a,b,c),b,c),b,c) 
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=UniversalUnfolding and _params['q']=SmoothGerms and _params['q_in']=NULL then    
		RECOGNITIONGerm(NormalformGerm(mtaylor(a,b,c),b,c),b,c)
	fi;          
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
MultMatrix:=proc(a,b,c,d,q)
	if _params['a']<>NULL and _params['b']<>NULL and _params['c']=NULL and _params['d']=NULL and _params['q']=NULL then
		MultMatrixFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']=Fractional and _params['d']=NULL and _params['q']=NULL then
		MultMatrixFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['q']=Fractional then
		MultMatrixFractionalRing(a,b,d,c)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and  _params['q']=NULL then
		MultMatrixFractionalRing(a,b,d,c)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['q']=Polynomial then
		MultMatrixPolynomial(a,b,d,c)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']=Polynomial and _params['q']=NULL then
		MultMatrixPolynomialRing(a,b,c)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['q']=Formal then
		MultMatrixFormal(a,b,c,d)
	elif _params['a']<>NULL and _params['b']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['q']=SmoothGerms then
		MultMatrixGerm(a,b,c,d)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
CheckUniversal := proc(a,b,c,d,s)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']<>NULL and whattype(d)=integer and _params['s']<>NULL then
           CheckUniversal_at_non_zero_point(a,b,c,d,rhs(s))
       elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=list and _params['d']=NULL then
           CheckUniversal_old(a,b,c)[2]
       end if:
end proc:
#>-----------------------------------------------------------------------------
CheckUniversal_at_non_zero_point:=proc(GG, params, vars, k, point_in)
local g, g_taylor:
      g := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],GG);
      g_taylor := mtaylor(g, [X,Y], k+1);
      return(CheckUniversal_old(g_taylor, params, [X,Y])[2]);
end proc:
#>-----------------------------------------------------------------------------
CheckUniversal_old:=proc(GG, params, vars)
#option trace;
local AA,h,c,d,ET,B,A,t,C,K,z,KK,MM,N,hf;
with(LinearAlgebra):
	AA := `minus`(indets(GG), {vars[2], vars[1]});
	hf := subs([seq(params[i] = 0, i = 1 .. nops(AA))], GG);
	h := subs(a = 1, NormalformFractional(hf,vars));
	c := ComplemenT(PRNEW(h,vars),vars);
	d := SPERP(h, vars);
	ET := PRTT2(h,vars);
	B := [diff(g(vars[1], vars[2]), `$`(vars[1], 1)), diff(g(vars[1], vars[2]), `$`(vars[2], 1))];
	A := NULL;
	for t in B do
		if {op( FINDPOWER(DERIVATIVE(c,t,vars),DERIVATIVE(d,g(vars[1],vars[2]),vars)))}<>{0} then
			A := A, t;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(params[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(params[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(vars[1], vars[2]),vars));
	od;
	KK := subs([seq(params[i] = 0, i = 1 .. nops(ET))], [K]);
	MM := eval(subs(g = unapply(h, vars[1], vars[2]), G = unapply(GG, vars[1], vars[2], seq(params[i], i = 1 .. nops(AA))), KK));
	N := convert(MM, Matrix);
	if Determinant(N)=0 then
		return([0,"no"]);
	else
		return([1,"yes"]);
	fi;
   end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF1Frac:=proc(Z,V,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, z, A, ES, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(STD(FF,vars,Ds))} minus {0})];
	#S:=STD(Z,[x,lambda],Ds);
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if MoraNF(m,S)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
		if degree(k,vars[2]) >= j then
			RETURN(true);
		fi;
		RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				OUT:=Intrinsic2Frac([OUT],V,Z,vars);
				# return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=STD([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,Ds);
					A:={seq(MoraNF(simplify(f-mtaylor(f,vars,MaxPower+1)),ES),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to 20");
				fi;
				#return(OUT);
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2Frac:=proc(Z,MaxPower,V,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, um, ES, A, INS;
	um:=MaxPower;
	OUT:=NULL;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(STD(FF,vars,Ds))} minus {0})];
	#S:=STD(Z,[x,lambda],Ds);
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if MoraNF(m,S)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		 RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else 
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then 
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else 
				OUT:=Intrinsic2Frac([OUT],V,Z,vars);
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=STD([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,Ds);
					A:={seq(MoraNF(simplify(f-mtaylor(f,vars,MaxPower+1)),ES),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to= ",um);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF1Ge:=proc(Z,V,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(StandardBasisGerm(FF,vars,20))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if DivAlgGerm(m,S,20,vars)<>0 then
			 MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				OUT:=Intrinsic2Ge([OUT],V,Z,MaxPower,vars);
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
         
					 ES:=StandardBasisGerm([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,20);
					 A:={seq(DivAlgGerm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,20,vars),f=Z)};
				fi;
				 if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2Ge:=proc(Z,MaxPower,V,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;	
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(StandardBasisGerm(FF,vars,MaxPower))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if DivAlgGerm(m,S,MaxPower,vars)<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				OUT:=Intrinsic2Ge([OUT],V,Z,MaxPower,vars);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=StandardBasisGerm([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],vars,MaxPower);
					A:={seq(DivAlgGerm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,MaxPower,vars),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi; 
end: 
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic2Frac:=proc(FF,V,ZZ,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	G :=FF;
	F1:= MonomTotal(G,vars);
	W := [op(V),seq(MoraNF(i,F1),i=ZZ)];
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				#if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa:= mahsa,MINIMAL1JA([f], F1, W,vars)[-1];
				#else
				# mahsa:= mahsa, MINIMAL1([f], F1, W)[2];
				# fi;
				A3 := MINIMAL1JA([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				#if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				# else
				# mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A1 := MINIMAL1JA([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				#if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				#else
				#mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A2 := MINIMAL1JA([f], F1, W,vars);
				W := A2[1];
			else
				# if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				# else
				#  mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A := MINIMAL1JA([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			# if nops([MINIMAL2([f],F1,W)])= 1 then
			mahsa := mahsa, MINIMAL2JA([f], F1, W,vars)[-1];
			# else
			#mahsa := mahsa, MINIMAL2([f], F1, W)[2];
			# fi;
			B := MINIMAL2JA([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			# if nops([MINIMAL3([f],F1,W)])= 1 then
			mahsa := mahsa, MINIMAL3JA([f], F1, W,vars)[-1];
			# else
			# mahsa := mahsa, MINIMAL3([f], F1, W)[2];
			# fi;
			C := MINIMAL3JA([f], F1, W,vars);
			W := C[1];
		fi;
	od;
	#a := NULL;
	#for t in [mahsa] do
	#a := a, subs(lambda^degree(t, lambda) = `<,>`(lambda^degree(t, lambda)), t);
	#od;
	#L := `minus`({op(W)}, {0});
	#K := add(i, i = [a]);
	#print("Intrinsic part is=",K);
	return(mahsa);
	end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic2Ge:=proc(FF,V,ZZ,MaxPower,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	#Kazemi1:=Itr1(F)[-1];
	#Kazemi2:=Support(Kazemi1,[x,lambda]);
	#Kazemi3:=seq([degree(s,x),degree(s,lambda)],s=Kazemi2);
	G :=FF;
	F1:= MonomTotal(G,vars);
	W := [op(V),seq( DivAlgGerm(i,F1,MaxPower,vars),i=ZZ)];
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				#if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa:= mahsa,MINIMAL1JA([f], F1, W,vars)[-1];
				#else
				#mahsa:= mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A3 := MINIMAL1JA([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				# if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				#else
				# mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A1 := MINIMAL1JA([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				#if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				# else
				# mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A2 := MINIMAL1JA([f], F1, W,vars);
				W := A2[1];
			else
				# if nops([MINIMAL1([f],F1,W)])= 1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				#else
				# mahsa := mahsa, MINIMAL1([f], F1, W)[2];
				#fi;
				A := MINIMAL1JA([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			#if nops([MINIMAL2([f],F1,W)])= 1 then
			mahsa := mahsa, MINIMAL2JA([f], F1, W,vars)[-1];
			# else
			#mahsa := mahsa, MINIMAL2([f], F1, W)[2];
			#fi;
			B := MINIMAL2JA([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			# if nops([MINIMAL3([f],F1,W)])= 1 then
			mahsa := mahsa, MINIMAL3JA([f], F1, W,vars)[-1];
			# else
			# mahsa := mahsa, MINIMAL3([f], F1, W)[2];
			#fi;
			C := MINIMAL3JA([f], F1, W,vars);
			W := C[1];
		fi;
	od;
	return(mahsa);
	#a := NULL;
	#for t in [mahsa] do
	#a := a, subs(lambda^degree(t, lambda) = `<,>`(lambda^degree(t, lambda)), t);
	#od;
	#L := `minus`({op(W)}, {0});
	# K := add(i, i = [a]);
	#print("Intrinsic part is=",K);
	end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
MINIMAL1JA:=proc(F,F1,V,vars)
#option trace;
local f,flag,i,M,MM,N,t,j,W,k,H,G,K,KK,MN,MH;
	G := F;
	if G[1][1]=1 and G[1][2]=1 then
		if SNF(vars[2],F1,V,vars)=0 then
			KK := [0, 1];
		else
			KK := [1, 1];
		fi;
		W := NULL;
		for k in V do
			W := W, NormalForm(k, MonomTotal([KK],vars), plex(vars[1], vars[2]));
		od;
			return([W],M^KK[1]*vars[2]^KK[2],[KK[1],KK[2]]);
	fi;
	if G[1][1]=1 then
		if SNF(vars[2]^G[1][2],F1,V,vars)=0 then
			return(MINIMAL3([[0, G[1][2]]], F1, V,vars));
		else
			flag:=false;
			for j from G[1][2]-1 to 1 by -1 while flag=false do
				MN := vars;
				N := NULL;
				for t in MN do
					if SNF(t*vars[2]^j,F1,V,vars)<>0 then
						flag := true;
					else
						N := N, t;
					fi;
				od;
			od;
			K := [1, j+2];
		fi;
		W := NULL;
		for k in V do
			W := W, NormalForm(k, MonomTotal([K],vars), plex(vars[1], vars[2]));
		od;
		return([W],M^K[1]*vars[2]^K[2],[K[1],K[2]]);
	else
		flag := false;
		for i from G[1][1]-1 to 0 by -1 while flag=false do 
			MH := [MonomialMaker(i,vars)];
			N := NULL;
			for t in MH do 
				if SNF(t*vars[2]^(G[1][2]),F1,V,vars)<>0 then 
					flag := true;
				else 
					N := N, t;
				fi;
			od;
		od;
		H := [[i+2, G[1][2]]];
	fi;
	MM := MonomialMaker(i+2,vars);
	for f in H do
		if f[2]=1 then
			K := [i+2, 1];
		else
			flag := false;
			for j from f[2]-1 to 0 by -1 while flag=false do
				N := NULL;
				for t  in MM do 
					if SNF(t*vars[2]^(j),F1,V,vars)<>0 then
						flag := true;
					else
						N := N, t;
					fi;
				od;
			od;
			K := [i+2, j+2];
		fi;
	od;
	W := NULL;
	for k in V do
		W := W, NormalForm(k, MonomTotal([K],vars), plex(vars[1], vars[2]));
	od;
	return ([W], M^K[1]*vars[2]^K[2],[K[1],K[2]]);
 end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###########################################MINIMAL2
MINIMAL2JA:=proc(F,F1,V,vars)
#option trace;
local G,flag,i,MM,N,t,W,j; 
	G := F; 
	flag := false;
	for i from G[1][1]-1 to 1 by -1 while flag=false  do
		MM := [MonomialMaker(i,vars)];
		N := NULL;
		for t in MM do
			if SNF(t,F1,V,vars)<>0 then
				flag := true;
			else
				N := N, t;
			fi;
		od;
	od;
	W := NULL;
	for j in V do
		W := W, NormalForm(j, [MonomialMaker(i+2,vars)], plex(vars[1], vars[2]));
	od;
	return([W], M^(i+2),[i+2,0]);
 end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######################################MINIMAL3
MINIMAL3JA:=proc(F,F1,V,vars)
#option trace;
local G,flag,i,N,W,j,K,q; 
	G := F;
	if G[1][2]=1 then
		if SNF(vars[2],F1,V,vars)=0 then
			K := vars[2];
		else
			K := 0;
		fi;
		W := NULL;
		for j in V do
			W := W, NormalForm(j, [K], plex(vars[1], vars[2]));
		od;
		if K=0 then
			return(K,[0,0]);
		elif K=vars[2] then
			return(K,[0,1]);
		fi;
	else
		q:=vars[2]^(F[1][2]);
	fi;
	W := NULL;
	for j in V do
		W := W, NormalForm(j, [q], plex(vars[1], vars[2]));
	od;
		# return([W], lambda^(i+2));
		return([W], vars[2]^(F[1][2]),[0,F[1][2]]);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#################################################why you put these two algorithms here?find the solution very soon##############################
ItrTrunc1:=proc(Ideal,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	#F:=[g,lambda*diff(g,x),x*diff(g,x)];
	F:=[seq(mtaylor(i,vars,20),i=Ideal)];
	S:=STD(F,[vars[2],vars[1]],Ds);
	LMS:=LM(S); 
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	#flag:=true;
	#fi;
	#od;
	#if flag then
	#for i from 1 to nops(S) while flag do
	#if indets(LMS[i])={lambda} then
	#flag:=false;
	#fi;
	#od;
	#if flag then
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	#else
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {vars[1],vars[2]} do         
		M:=MultMatrixFractional(S,u):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od: 
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi; 
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if MoraNF(m,S)<>0 then                    
				flag:=false;
			else         
				#RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if MoraNF(m,S)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MM<>{} do
		 MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		 else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];

	Y:=seq(MoraNF(F[i],L),i=1..nops(F));
	M:='M';
	#L:=subs(y=lambda,L);
	#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(MoraNF(F[i],L),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(vars[1],vars[2])),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
		#    RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
	#RETURN(OUT);  
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
ItrTrunc2:=proc(Ideal,k,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	#F:=[g,lambda*diff(g,x),x*diff(g,x)];
	F:=[seq(mtaylor(i,vars,k),i=Ideal)];
	S:=STD(F,[vars[2],vars[1]],Ds);
	LMS:=LM(S); 
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	#flag:=true;
	#fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	# if indets(LMS[i])={lambda} then
        # flag:=false;
	#fi;
	#od;
	#if flag then
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	#else
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {vars[1],vars[2]} do         
		M:=MultMatrixFractional(S,u):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if MoraNF(m,S)<>0 then                    
				flag:=false;
			else         
				#RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if MoraNF(m,S)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2])>= j then
		RETURN(true);
	fi;
		RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MM<>{} do
		MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
	Y:=seq(MoraNF(F[i],L),i=1..nops(F));
	M:='M';
	#L:=subs(y=lambda,L);
	#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(MoraNF(F[i],L),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(vars[1],vars[2])),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
		#    RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
	#RETURN(OUT);  
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
########################computations in ring of polynomials with truncation degree###
NormalformPolynomial:=proc(ggg,vars,z,k)
	if _params['ggg'] <> NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z'] <> NULL and whattype(z)=integer and _params['k'] = NULL then
		NF2Polynomial(ggg,z,vars)
	elif _params['ggg'] <> NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z'] <> NULL and whattype(z)=integer and _params['k'] = list then
		NF1Polynomial(ggg,z,vars)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
NF1Polynomial:=proc(ggg,k,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	g:=mtaylor(ggg,vars,k);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	high:=Itr2Polynomial(S,k,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		print("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1Polynomial(S,k,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2Polynomial(g,vars,k)[-1])}; 
	Pperp:={op(NSetPolynomial([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=Basis(P0,plex(vars[1],vars[2])))],k,vars))};
	A:=Pperp minus Sperp;
	C:={op(IG2Polynomial(g,vars,k)[2])}; 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			od;
		od;
		d:=d-1;
	od;
	H:=seq(expand(subs(op(s),g)),s=[SS]);
	RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################second one
NF2Polynomial:=proc(ggg,k,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	g:=mtaylor(ggg,vars,k);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	high:=Itr2Polynomial(S,k,vars);
	if whattype(high)=integer then
	if k<high then
		print("Degree of high order terms start with=",high);
		print("The truncation degree must be higher than or equal to=",high-1);
	fi;
	else
		return();
	fi;
	IT:=Itr1Polynomial(S,k,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2Polynomial(g,vars,k)[-1])}; 
	Pperp:={op(NSetPolynomial([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=Basis(P0,plex(vars[1],vars[2])))],k,vars))};
	A:=Pperp minus Sperp;
	C:={op(IG2Polynomial(g,vars,k)[2])};
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				fi;
			od;
		od;
		if flag then
			d:=d-1;
		fi;
	od;
	g:=expand(subs(ss,g));
	RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr2Polynomial:=proc(Ideal,k,vars)
#option trace;
local F,S,LMS,flag,i,MaxPower,u,M,p,Monoms,m,NEWPOINT,esfahan;
	F:=Ideal;
	S:=Basis(F,plex(vars[1],vars[2])); 
	LMS:=[seq(LeadingMonomial(i,plex(vars[1],vars[2])),i=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	#   flag:=true;
	# fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	#if indets(LMS[i])={lambda} then
        #   flag:=false;
	# fi;
	#od;
	# if flag then
	#RETURN("The ideal is of infinite codimension.");
	#fi;
	#else
	# RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0;  
	NEWPOINT:=NULL;
	for u in {op(vars)} do         
		# M:=MultMatrixPolynomial(S,u,k):         
		#  p:=MinimalPolynomial(M,u):
		p:=EliminationIdeal(<op(S)>,{u});
		NEWPOINT:=NEWPOINT,op(IdealInfo[Generators](p));
		MaxPower:=max(MaxPower,degree(p)):  
	od: 
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		printf("The polynomial germ ring is not suitable for normal form computations.\nUse the command Verify to find the appropriate computational ring\nThe following output might be wrong.\nThe germ is an infinite codimensional germ.\nThe high order term ideal contains");
		#return("The high order term ideal contains=",Itr1Polynomial(F,k));
		return Itr1Polynomial(F,k,vars);
	return("The high order term ideal contains",Itr1Polynomial(F,k,vars));
	fi;
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:        
		for m in Monoms while flag do 
			if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then                    
				flag:=false;
			else                     
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:     
		fi;  
	od:    
	return(MaxPower);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr1Polynomial:=proc(Ideal,k,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	F:=Ideal;
	S:=Basis(F,plex(vars[1],vars[2]));
	LMS:=[seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	#  if indets(LMS[i])={x} then
	# flag:=true;
	# fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	# if indets(LMS[i])={lambda} then
	#  flag:=false;
	# fi;
	#od;
	#if flag then
	# RETURN("The ideal is of infinite codimension.");
	# fi;
	#else
	# RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0;
	NEWPOINT:=NULL;  
	for u in {op(vars)} do         
		#M:=MultMatrixPolynomial(S,u,k):         
		#p:=MinimalPolynomial(M,u):
		p:=EliminationIdeal(<op(S)>,{u});
		NEWPOINT:=NEWPOINT,op(IdealInfo[Generators](p));
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then             
				flag:=false;
				#       else         
				#           RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
		od:    
		OUT:=[MaxPower];
		if OUT[1]>k then
			print("The truncation degree is not sufficient and the result might be wrong. Suggestion:
 use command Verify to find the appropriate truncation degree.");
		fi;
		M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
		for m in M do
			if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
				M:=M minus {m};
			fi;
		od;
		SelFun:=proc(kk,j,vars)
		if degree(kk,vars[2]) >= j then
			RETURN(true);
		fi;
		RETURN(false);
		end:
		j:=1;
		ind:=MaxPower;
		while MM<>{} do
		MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
	Y:=seq(NormalForm(F[i],L,plex(vars[1],vars[2])),i=1..nops(F));
	M:='M';
	#L:=subs(y=lambda,L);
	#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(NormalForm(F[i],L,plex(vars[1],vars[2])),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(vars[1],vars[2])),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
		#    RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
		#RETURN(OUT);  
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
MultMatrixPolynomial:=proc(SS,u,k,vars)
global t;
local L,n,M,i,v,j,c,S;
#option trace;
	S:=SS;
	L:=NSetPolynomial([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=S)],k,vars);
	n:=nops(L);
	M:=Matrix(n);
	for i from 1 to n do
		v:=NormalForm(u*L[i],S,plex(vars[1],vars[2]));
		M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				M[j,i]:=c;
			fi;
		od;
	od;
	RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
IG2Polynomial:= proc (ff, V,k) 
#option trace;
local II,M,N,T,SortFun,S,NN,NNN,C,ZC,MaxPowerOfM,MinPowerOfMl,flag,q,L,i,MM,SB,ll;
	M:='M';
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
		if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			 RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
	end:
	N:=sort([N],SortFun);
	S := 0;
	NN := 0;
	NNN := 0;
	C := NULL;
	ZC:=NULL;
	II:=NULL;
	MaxPowerOfM:=0;
	MinPowerOfMl:=infinity;
	flag:=false;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
			if q[-1] <> 0 then 
				if q[1]<>0 and (not flag or q[1]+q[-1]<MaxPowerOfM) then
					NN := NN+M^q[1]*`<,>`(V[2]^q[-1]);
					NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]); 
					MinPowerOfMl:=min(MinPowerOfMl,q[1]+q[-1]);
				elif q[1]=0 and (not flag or q[1]+q[-1]<MaxPowerOfM) and (q[-1]<MinPowerOfMl) then
					NN := NN+`<,>`(V[2]^q[-1]);
					NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]);                 
				fi;
			elif q[1]<>0 and not flag then
				NN := NN+M^q[1];
				NNN := NNN,V[1]^q[1];
				C:=C,Diff(f,V[1]$q[1]);
				MaxPowerOfM:=q[1]; 
				flag:=true;
			end if; 
				#NNN := NNN,x^q[1]*lambda^q[-1]; 
				#C := C, diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))<>0; 
				#L:=NULL;
				#for i from 1 to nops(V) do
				#    if q[i]<>0 then
				#        L:=L,seq(V[i],j=1..q[i]);
				#    fi;
				#od;
				#if L=NULL then
				#    C:=C,f<>0;
				#else
				#    C := C, Diff(f,subs(y=lambda,[L]))<>0; 
				#fi;
				if q[1]<>0 then
					MM:=[MonomialMaker(q[1],V)];
					II:=II,op(expand(V[2]^q[-1]*MM));
				elif q[2]<>0 then
					II:=II, V[2]^q[-1];
				fi;
		end if; 
	end do;  
	SB:=Basis([II],plex(V[1],V[2]));  
	N:=NSetPolynomial([seq(LeadingMonomial(f,plex(V[1],V[2])),f=SB)],k,V);
	ll:=1;
	if  1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,V[1]$degree(v,V[1]),V[2]$degree(v,V[2]))=0,v in N[ll..-1])];
	RETURN(NN, {NNN} minus {0}, C ,N); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
NSetPolynomial := proc (LL,k,vars) 
#option trace;
local g,L,V, d, N, v, x, m, i, j, u, flag, l; 
	L:={seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=LL)};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PRTT2Polynomial:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Polynomial(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSetPolynomial([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)],k,vars);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRTT2newPolynomial:=proc(ggg,vars,k)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Polynomial(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		 else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else	
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSetPolynomial([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)],k,vars);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg1(h,{op(RNF),H},[vars[2],vars[1]]);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfoldingPolynomial:=proc(a,b,c,k,q)
	if _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=integer and _params['k']= NULL and _params['q']= NULL then
		UniversalUnfolding1Polynomial(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=integer and _params['k']=list and _params['q']= NULL then
		UniversalUnfolding2Polynomial(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=integer and _params['k']=normalform and _params['q']= NULL then 
		UniversalUnfolding1Polynomial(a,b,c)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list  and _params['c']<>NULL and whattype(c)=integer and _params['k']=normalform and _params['q']= list then  
		UniversalUnfolding2Polynomial(a,b,c)[2]
	fi;  
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfolding1Polynomial:=proc(g,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET:=PRTT2Polynomial(g,vars,k);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformPolynomial(g,vars,k)+add(alpha[i]*ET[i],i=1..nops(ET));
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfolding2Polynomial:=proc(g,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4,S;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	if Itr1Polynomial(S,k,vars)="The ideal is of infinite codimension." then
		printf("The ring of polynomial germs is not suitable for normal form computations of the input germ\nThe permissible computational ring options are Fractional SmoothGerms and Formal");
	else
		ET1:=PRTT2Polynomial(g,vars,k);
		ET2:=PRTT2newPolynomial(g,vars,k);
		G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
		G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
		G3:=NormalformPolynomial(g,vars,k)+add(alpha[i]*ET1[i],i=1..nops(ET1));
		G4:=NormalformPolynomial(g,vars,k)+add(alpha[i]*ET2[i],i=1..nops(ET2));
		return([[G1,G2],[G3,G4]]);
	end if:
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic1Polynomial:=proc(L,k,vars)
#option trace;
local firsttime, firstbytes, II;
	L:=[seq(mtaylor(i,vars,k+1),i=L)];
	II:=Itr1Polynomial(L,k,vars);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic2Polynomial:=proc(F,V,k,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
 global F1;
	F:=[seq(mtaylor(i,vars,k+1),i=F)];
	Kazemi1:=Itr1Polynomial(F,k,vars)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1Polynomial(F,k,vars)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
	od;
	a := NULL;
	for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
	od;
	L := `minus`({op(W)}, {0});
	K := add(i, i = [a]);
	print("Intrinsic part is=",K);
        end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntrinsicPolynomial:=proc(U,V,W,k)
	if _params['U']<>NULL and _params['V']<>NULL and whattype(V)=list and _params['W']<>NULL and whattype(W)=integer and _params['k']=NULL  then
		Intrinsic1Polynomial(U,W,V)
	elif _params['U']<>NULL and _params['V']<>NULL and _params['W']<>NULL and  whattype(W)=list and _params['k']<>NULL and whattype(k)=integer then
		Intrinsic2Polynomial(U,V,k,W)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPERPPolynomial:= proc (ff, V,k) 
#option trace;
local N,T,SortFun,II,q,MM,SB;
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
	if p[1]=q[1] then
		RETURN(evalb(p[2]<q[2]));
	else
		RETURN(evalb(p[1]<q[1]));
	fi;
	fi;
	end:
	N:=sort([N],SortFun);
	II:=NULL;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
			if q[1]<>0 then
				MM:=[MonomialMaker(q[1],V)];
				II:=II,op(expand(V[2]^q[-1]*MM));
			elif q[2]<>0 then
				II:=II, V[2]^q[-1];
			fi;
		end if; 
	end do; 
	SB:=Basis([II],plex(V[1],V[2]));
	N:=NSett([seq(LeadingMonomial(f,plex(V[1],V[2])),f=SB)],k);
	return(N);
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
GermRecognitionPolynomial:=proc(h,k,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			 B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomial(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	print("S=",mahh);#(h)
	#print("Nonzero condition=",[AB]);
	print("S^{h}=",{op(SPERPPolynomial(add(i,i=[op(P)]),vars,k))});#^{⊥}(h)
	print("intrinsic generators=",P);
	#print('zero condition=',ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
AlgObjectsPolynomial:=proc(ggg,k,vars)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Polynomial(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);	
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognitionPolynomial(g,k,vars));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
germrecognitionPolynomial:=proc(h,k,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomial(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	#print("intrinsic generators=",P);
	#print("S=",mahh);
	print("Nonzero condition=",[AB]);
	#print("SPERP=",SPERP(add(i,i=[op(P)]),[x,lambda]));
	print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRNEWPolynomial:=proc(ggg,k,vars)
#option trace;
local Kazemi,Kazemi1,Kazemi2,Kazemi3,Kazemi4;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Polynomial(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	#print(Kazemi3,Kazemi4);
	return([Kazemi3]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
RECOGNITIONPolynomial:=proc(h,kk,vars)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEWPolynomial(h,kk,vars),vars);
	d := SPERPPolynomial(h, vars,kk);
	ET := PRTT2Polynomial(h,vars,kk);
	B := [diff(g(vars[1], vars[2]), `$`(vars[1], 1)), diff(g(vars[1], vars[2]), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(vars[1],vars[2]),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(vars[1], vars[2]),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			 else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		E := NULL;
		for hh in k do
			if hh=0 then
				E := E, hh;
			elif {op( op(0,hh))}subset {vars[1],vars[2]} then
				E := E, hh;
			else
				HH := subs(g = G, hh);
				E := E, HH;
			fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
###############line1:mtaylor(f,[x,lambda],4)#########line2:mtaylor(f,[x,lambda],6)######
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
RecognitionProblemPolynomial:=proc(f,c,k,q)
	if _params['f'] <>NULL and _params['c']<> NULL and whattype(c)=list and _params['k']<>NULL and whattype(k)=integer and _params['q']=NULL then
		germrecognitionPolynomial(NormalformPolynomial(f,c,k),k,c)
	elif _params['f'] <>NULL and _params['c']<>NULL and whattype(c)=list and _params['k'] <>NULL and
		whattype(k)=integer and _params['q']=universalunfolding then
		RECOGNITIONPolynomial(NormalformPolynomial(f,c,k),k,c)
	end if:
 end proc:
###############################################for infinit codim ideals in polynomial ring
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
INF1Polynomial:=proc(Z,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq((vars[1])^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			 MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2]);
				else
         
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
INF2Polynomial:=proc(Z,MaxPower,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq((vars[1])^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2]);
				else
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi; 
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
INF1Pol:=proc(Z,V,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				OUT:=Intrinsic2Po([OUT],V,Z,MaxPower,vars);
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
INF2Pol:=proc(Z,MaxPower,V,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;
	FF:=[seq(mtaylor(f,vars,MaxPower+1),f=Z)];
	#FF:=[FF[1],x*diff(FF[1],x),lambda*diff(FF[1],x)];
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				OUT:=Intrinsic2Po([OUT],V,Z,MaxPower,vars);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic2Po:=proc(FF,V,ZZ,MaxPower,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	G :=FF;
	F1:= MonomTotal(G,vars);
	W := [op(V),seq( NormalForm(i,F1,plex(vars[1],vars[2])),i=ZZ)];
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				mahsa:= mahsa,MINIMAL1JA([f], F1, W,vars)[-1];
				A3 := MINIMAL1JA([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A1 := MINIMAL1JA([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A2 := MINIMAL1JA([f], F1, W,vars);
				W := A2[1];
			else
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A := MINIMAL1JA([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
				mahsa := mahsa, MINIMAL2JA([f], F1, W,vars)[-1];
				B := MINIMAL2JA([f], F1, W,vars);
				W := B[1];
		elif f[1]=0 and f[2]<>0 then
				mahsa := mahsa, MINIMAL3JA([f], F1, W,vars)[-1];
				C := MINIMAL3JA([f], F1, W,vars);
				W := C[1];
		fi;
	od;
	return(mahsa);
	end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
########################computations in ring of polynomials################
NormalformPolynomialRing:=proc(ggg,vars,z)
	if _params['ggg'] <> NULL and _params['vars']<>NULL and whattype(vars)=list and _params['z']=NULL then
		NF2PolynomialRing(ggg,vars)
	elif _params['ggg'] <> NULL and _params['vars']<>NULL and whattype(vars)=list  and _params['z'] = list then
		NF1PolynomialRing(ggg,vars)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
NF1PolynomialRing:=proc(ggg,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	g:=ggg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2PolynomialRing(g,vars)[-1])}; 
	Pperp:={op(NSetPolynomialRing([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=Basis(P0,plex(vars[1],vars[2])))],vars))};
	A:=Pperp minus Sperp;
	C:={op(IG2PolynomialRing(g,vars)[2])}; 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			od;
		od;
		d:=d-1;
	od;
	H:=seq(expand(subs(op(s),g)),s=[SS]);
	RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
###################################second one$####
NF2PolynomialRing:=proc(ggg,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,Sprim,high;
	g:=ggg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2PolynomialRing(g,vars)[-1])}; 
	Pperp:={op(NSetPolynomialRing([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=Basis(P0,plex(vars[1],vars[2])))],vars))};
	A:=Pperp minus Sperp;
	C:={op(IG2PolynomialRing(g,vars)[2])};
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				fi;
			od;
		od;
		if flag then
			d:=d-1;
		fi;
	od;
	g:=expand(subs(ss,g));
	RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr2PolynomialRing:=proc(Ideal,vars)
#option trace;
local F,S,LMS,flag,i,MaxPower,u,M,p,Monoms,m,NEWPOINT,esfahan;
	F:=Ideal;
	S:=Basis(F,plex(vars[1],vars[2])); 
	LMS:=[seq(LeadingMonomial(i,plex(vars[1],vars[2])),i=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	#  flag:=true;
	#  fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	#  if indets(LMS[i])={lambda} then
	#   flag:=false;
	# fi;
	# od;
	# if flag then
	#   RETURN("The ideal is of infinite codimension.");
	# fi;
	#else
	#  RETURN("The ideal is of infinite codimension.");
	#fi;
	NEWPOINT:=NULL;
	MaxPower:=0;  
	for u in {vars[1],vars[2]} do         
		# M:=MultMatrixPolynomialRing(S,u):         
		# p:=MinimalPolynomial(M,u):
		p:=EliminationIdeal(<op(S)>,{u});
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od: 
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:        
		for m in Monoms while flag do 
			if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then                    
				flag:=false;
			else                     
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	return(MaxPower);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr1PolynomialRing:=proc(Ideal,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT;
	F:=Ideal;
	S:=Basis(F,plex(vars[1],vars[2]));
	LMS:=[seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=S)];
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	# flag:=true;
	# fi;
	#od;	
	#if flag then
	#for i from 1 to nops(S) while flag do
	# if indets(LMS[i])={lambda} then
	#   flag:=false;
	# fi;
	# od;
	# if flag then
	# RETURN("The ideal is of infinite codimension.");
	# fi;
	#else
	#  RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {op(vars)} do         
		# M:=MultMatrixPolynomialRing(S,u):         
		# p:=MinimalPolynomial(M,u):
		p:=EliminationIdeal(<op(S)>,{u});
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then             
				flag:=false;
				#       else         
				#           RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(kk,j,vars)
	if degree(kk,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MM<>{} do
		MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
	Y:=seq(NormalForm(F[i],L,plex(vars[1],vars[2])),i=1..nops(F));
	M:='M';
	#L:=subs(y=lambda,L);
	#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(NormalForm(F[i],L,plex(vars[1],vars[2])),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(vars[1],vars[2])),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
		#    RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
	#RETURN(OUT);  
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
MultMatrixPolynomialRing:=proc(S,u,vars)
global t;
local L,n,M,i,v,j,c;
#option trace;
	L:=NSetPolynomialRing([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=S)],vars);
	n:=nops(L);
	M:=Matrix(n);
	for i from 1 to n do
		v:=NormalForm(u*L[i],S,plex(vars[1],vars[2]));
		M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				M[j,i]:=c;
			fi;
		od;
	od;
	RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IG2PolynomialRing:= proc (ff,V) 
#option trace;
local II,M,N,T,SortFun,S,NN,NNN,C,ZC,MaxPowerOfM,MinPowerOfMl,flag,q,L,i,MM,SB,ll;
	M:='M';	
	N := NULL;	
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
	end:
	N:=sort([N],SortFun);
	S := 0;
	NN := 0;
	NNN := 0;
	C := NULL;
	ZC:=NULL;
	II:=NULL;
	MaxPowerOfM:=0;
	MinPowerOfMl:=infinity;
	flag:=false;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then 
			if q[-1] <> 0 then 
				if q[1]<>0 and (not flag or q[1]+q[-1]<MaxPowerOfM) then
					NN := NN+M^q[1]*`<,>`(V[2]^q[-1]);
					NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]); 
					MinPowerOfMl:=min(MinPowerOfMl,q[1]+q[-1]);
				elif q[1]=0 and (not flag or q[1]+q[-1]<MaxPowerOfM) and (q[-1]<MinPowerOfMl) then
					NN := NN+`<,>`(V[2]^q[-1]);
					NNN := NNN,V[1]^q[1]*V[2]^q[-1];
					C:=C,Diff(f,V[1]$q[1],V[2]$q[2]);                 
				fi;
			elif q[1]<>0 and not flag then
					NN := NN+M^q[1];
					NNN := NNN,V[1]^q[1];
					C:=C,Diff(f,V[1]$q[1]);
					MaxPowerOfM:=q[1]; 
					flag:=true;
			end if; 
			#NNN := NNN,x^q[1]*lambda^q[-1]; 
			#C := C, diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))<>0; 
			#L:=NULL;
			#for i from 1 to nops(V) do
			#    if q[i]<>0 then
			#        L:=L,seq(V[i],j=1..q[i]);
			#    fi;
			#od;
			#if L=NULL then
			#    C:=C,f<>0;
			#else
			#    C := C, Diff(f,subs(y=lambda,[L]))<>0; 
			#fi;
			if q[1]<>0 then
				MM:=[MonomialMaker(q[1],V)];
				II:=II,op(expand(V[2]^q[-1]*MM));
			elif q[2]<>0 then
				II:=II, V[2]^q[-1];
			fi;
		end if; 
	end do;  
	SB:=Basis([II],plex(V[1],V[2]));  
	N:=NSetPolynomialRing([seq(LeadingMonomial(f,plex(V[1],V[2])),f=SB)],V);
	ll:=1;
	if  1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,V[1]$degree(v,V[1]),V[2]$degree(v,V[2]))=0,v in N[ll..-1])];
	RETURN(NN, {NNN} minus {0}, C ,N); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
NSetPolynomialRing:= proc(LL,vars) 
#option trace;
local g,L,V, d, N, v, x, m, i, j, u, flag, l; 
	L:={seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=LL)};
	N:=NULL;
	for l in L do
		flag:=false;
		for g in L minus {l} while not flag do
			if divide(l,g) then
				flag:=true;
			fi;
		od;
		if not flag then
			N:=N,l;
		fi;
	od;
	L:=[N];    
	V := indets(L); 
	N := 1; 
	for v in L do 
		if nops(indets(v)) = 1 then 
			x := indets(v)[1]; 
			N := N, seq(x^i, i = 1 .. degree(v)-1); 
		end if; 
	end do; 
	m := nops([N]); 
	for i from 2 to m do 
		for j from i+1 to m do
			if indets(N[i]) <> indets(N[j]) then 
				u := N[i]*N[j]; 
				flag := false; 
				for l in L while not flag do 
					if divide(u, l) then 
						flag := true; 
					end if; 
				end do; 
				if not flag then 
					N := N, u; 
				end if;
			fi; 
		end do; 
	end do; 
	RETURN([op({N})]); 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRTT2PolynomialRing:=proc(ggg,vars)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRTT2newPolynomialRing:=proc(ggg,vars)
#option trace;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS,Kazemi4;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);	
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;	
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSetPolynomialRing([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)],vars);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg1(h,{op(RNF),H},[vars[2],vars[1]]);
	od;
	ABS:={H}minus{0};
	return(ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfoldingPolynomialRing:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b'] <>NULL and whattype(b)=list  and _params['c'] = NULL and _params['d'] = NULL then
		UniversalUnfolding1PolynomialRing(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] = list and _params['d'] = NULL  then
		UniversalUnfolding2PolynomialRing(a,b)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] =normalform and _params['d'] = NULL then 
		UniversalUnfolding1PolynomialRing(a,b)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] = normalform and _params['d'] = list then  
		UniversalUnfolding2PolynomialRing(a,b)[2]
	fi;  
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding1PolynomialRing:=proc(g,vars)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET:=PRTT2PolynomialRing(g,vars);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformPolynomialRing(g,vars)+add(alpha[i]*ET[i],i=1..nops(ET));
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfolding2PolynomialRing:=proc(g,vars)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	ET1:=PRTT2PolynomialRing(g,vars);
	ET2:=PRTT2newPolynomialRing(g,vars);
	G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
	G3:=NormalformPolynomialRing(g,vars)+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G4:=NormalformPolynomialRing(g,vars)+add(alpha[i]*ET2[i],i=1..nops(ET2));
	return([[G1,G2],[G3,G4]]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic1PolynomialRing:=proc(L,vars)
#option trace;
local firsttime, firstbytes, II;
	II:=Itr1PolynomialRing(L,vars);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic2PolynomialRing:=proc(F,V,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
 global F1;
	Kazemi1:=Itr1PolynomialRing(F,vars)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1PolynomialRing(F,vars)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A2 := MINIMAL1([f], F1, W,vars);
				W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
			if nops([MINIMAL2([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL2([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
			fi;
			B := MINIMAL2([f], F1, W,vars);
			W := B[1];
		elif f[1]=0 and f[2]<>0 then
			if nops([MINIMAL3([f],F1,W,vars)])= 1 then
				mahsa := mahsa, MINIMAL3([f], F1, W,vars);
			else
				mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
			fi;
			C := MINIMAL3([f], F1, W,vars);
			W := C[1];
		fi;
	od;
	a := NULL;
	for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
	od;
	L := `minus`({op(W)}, {0});
	K := add(i, i = [a]);
	print("Intrinsic part is=",K);
	end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
IntrinsicPolynomialRing:=proc(U,V,W)
	if _params['U']<>NULL and _params['V']<>NULL and whattype(V)=list and _params['W']=NULL then
		Intrinsic1PolynomialRing(U,V)
	elif _params['U']<>NULL and _params['V']<>NULL and _params['W']<>NULL and whattype(W)=list then
		Intrinsic2PolynomialRing(U,V,W)
	fi;
end:    
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
SPERPPolynomialRing:= proc (ff, V) 
#option trace;
local N,T,SortFun,II,q,MM,SB;
	N := NULL; 
	T := cartprod([seq([seq(j, j = 0 .. degree(ff, V[i]))], i = 1 .. nops(V))]); 
	while not T[finished] do 
		N := N, T[nextvalue](); 
	end do; 
	SortFun:=proc(p,q)
	if p[1]=0 and q[1]<>0 then
		RETURN(false);
	fi;
	if p[1]=0 and q[1]=0 then
		RETURN(evalb(p[2]<q[2]));
	fi;
	if p[1]<>0 and q[1]=0 then
		RETURN(true);
	fi;
	if p[1]<>0 and q[1]<>0 then
		if p[2]=0 and q[2]<>0 then
			RETURN(true);
		fi;
		if p[2]<>0 and q[2]=0 then
			RETURN(false);
		fi;
		if p[1]=q[1] then
			RETURN(evalb(p[2]<q[2]));
		else
			RETURN(evalb(p[1]<q[1]));
		fi;
	fi;
	end:
	N:=sort([N],SortFun);
	II:=NULL;
	for q in N do 
		if subs(seq(V[i] = 0, i = 1 .. nops(V)), diff(ff, seq([`$`(V[i], q[i])], i = 1 .. nops(V)))) <> 0 then     
			if q[1]<>0 then
				MM:=[MonomialMaker(q[1],V)];
				II:=II,op(expand(V[2]^q[-1]*MM));
			elif q[2]<>0 then
				II:=II, V[2]^q[-1];
			fi;
		end if; 
	end do; 
	SB:=Basis([II],plex(V[1],V[2]));
	N:=NSett([seq(LeadingMonomial(f,plex(V[1],V[2])),f=SB)]);
	return(N);
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionPolynomialRing:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomialRing(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	print("S=",mahh);#"S"(h)=mahh
	#print("Nonzero condition=",[AB]);
	print("S^{⊥}=",{op(SPERPPolynomialRing(add(i,i=[op(P)]),vars))});#"S^{⊥}"(h)=SPERPPolynomialRing(add(i,i=[op(P)]),[x,lambda]);
	print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
AlgObjectsPolynomialRing:=proc(ggg,vars)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognitionPolynomialRing(g,vars));
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {}
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
germrecognitionPolynomialRing:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomialRing(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	#print("intrinsic generators=",P);
	#print("S=",mahh);
	print("Nonzero condition=",[AB]);
	#print("SPERP=",SPERP(add(i,i=[op(P)]),[x,lambda]));
	print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
PRNEWPolynomialRing:=proc(ggg,vars)
#option trace;
local Kazemi,Kazemi1,Kazemi2,Kazemi3,Kazemi4;
local RNF,IT,gg,t25,g,t1,t2,t3,t4,R0,X,S,P0,F,G,gy,l,K,II,ItrPart,VecSpace,SB,N,R,RRefined,r,H,h,A,i,B,f,C,RH,Q,Temp,M,j,WH,L,ABS;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	#print(P(g)=P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			#print(RT(g)=II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			#print(RT(g)=II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			#print(RT(g)=II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		 X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	#print(Kazemi3,Kazemi4);
	return([Kazemi3]);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
RECOGNITIONPolynomialRing:=proc(h,vars)
#option trace;
local c,ET,G,A,B,tt,d,C,K,z,W,N,F,g,gg,MM,k,E,hh,HH;
	c := ComplemenT(PRNEWPolynomialRing(h,vars),vars);
	d := SPERPPolynomialRing(h,vars);
	ET := PRTT2PolynomialRing(h,vars);
	B := [diff(g(vars[1], vars[2]), `$`(vars[1], 1)), diff(g(vars[1], vars[2]), `$`(vars[2], 1))];
	A := NULL;
	for tt in B do 
		if {op(FINDPOWER(DERIVATIVE(c,tt,vars),DERIVATIVE(d,g(vars[1],vars[2]),vars)))}<>{0} then 
			A := A,tt;
		fi;
	od;
	C := [A, seq(diff(G(vars[1], vars[2], seq(alpha[j], j = 1 .. nops(ET))), `$`(i, 1)), i = [seq(alpha[j], j = 1 .. nops(ET))])];
	K := NULL;
	for z in C do
		K := K, FINDPOWER(DERIVATIVE(c, z,vars), DERIVATIVE(d, g(vars[1], vars[2]),vars));
	od;
	W := subs([1 = vars[1], 2 = vars[2], 3 = alpha[1], 4 = alpha[2], 5 = alpha[3], D = g, g = 0, G = 0], [K]);
	N := NULL;
	for F in W do
		A := NULL;
		for gg in F do
			if gg=0 then
				A := A, gg;
			else
				A := A, op(0, gg);
			fi;
		od;
		N := N, [A];
	od;
	[N];
	MM := NULL;
	for k in [N] do
		E := NULL;
		for hh in k do
			if hh=0 then
				E := E, hh;
			elif {op( op(0,hh))}subset {vars[1],vars[2]} then
				E := E, hh;
			else
				HH := subs(g = G, hh);
				E := E, HH;
			fi;
		od;
		MM := MM, [E];
	od;
	[MM];
	return(det(convert([MM], Array)) <> 0);
    end:
###############line1:mtaylor(f,[x,lambda],4)#########line2:mtaylor(f,[x,lambda],6)######
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
RecognitionProblemPolynomialRing:=proc(f,c,d)
	if _params['f'] <>NULL and _params['c']<>NULL and whattype(c)=list and _params['d']=NULL then
		germrecognitionPolynomialRing(NormalformPolynomialRing(f,c),c)
	elif _params['f'] <>NULL and _params['c']=NULL and whattype(c)=list and _params['d'] = universalunfolding then
		RECOGNITIONPolynomialRing(NormalformPolynomialRing(f,c),c)
	end if:
 end proc:
###############################################for infinit codim ideals in polynomial ring
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF1PolynomialRing:=proc(Z,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=Z;
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
         
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,[vars[1],vars[2]],MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2PolynomialRing:=proc(Z,MaxPower,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;
	FF:=Z;
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi; 
end: 
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF1PolRing:=proc(Z,V,vars)
#option trace;
local OUT, MaxPower, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN, ES, A, INS;
	OUT:=NULL;
	MaxPower:=20;
	FF:=Z;
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
		RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				OUT:=Intrinsic2PoRing([OUT],V,Z,vars);
				#return(OUT);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else  
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
INF2PolRing:=proc(Z,MaxPower,V,vars)
#option trace;
local OUT, FF, S, MM, m, SelFun, j, ind, MMM, MMMM, B, i, MX, flag, L, Y, NN,A,INS,ES;
	OUT:=NULL;
	FF:=Z;
	S:=[op({op(Basis(FF,plex(vars[1],vars[2])))} minus {0})];
	MM:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq((vars[1])^t,t=1..MaxPower-1)};
	for m in MM do
		if NormalForm(m,S,plex(vars[1],vars[2]))<>0 then
			MM:=MM minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
	RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MMM<>{} do
		MMM:=select(SelFun,MM,j,vars);
		MMMM:={seq(expand(m/vars[2]^j),m=MMM)};
		if indets(MMMM)={vars[2]} and degree(MMMM[1])<ind then 
			OUT:=OUT,[0,degree(MMM[1])]; 
			MM:=MM minus {MMM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			if j<MaxPower then
				j:=j+1;
			else
				#return(OUT);
				OUT:=Intrinsic2PoRing([OUT],V,Z,MaxPower,vars);
				if nops([OUT])=1 then
					A:=AReplace(simplify(f-mtaylor(f,vars,MaxPower+1)),MaxPower,OUT[2],vars);
				else
					ES:=Basis([seq(seq(z*vars[2]^m[2],z=MonomialMaker(m[1],vars)),m=[OUT])],plex(vars[1],vars[2]));
					A:={seq(NormalForm(mtaylor(simplify(f-mtaylor(f,vars,MaxPower+1)),vars,50),ES,plex(vars[1],vars[2])),f=Z)};
				fi;
				if A={0} then
					INS:=add(M^i[1]*<vars[2]^i[2]>,i=[OUT]);
					return("Intrinsic part is=",INS);
				else
					return("Computations are correct modulo terms of degrees higher and equal to =",50);
				fi;
			fi;
		fi;
	od;
	if nops([OUT])=0 then
		return("no intrinsic part");
	fi; 
end: 
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
Intrinsic2PoRing:=proc(FF,V,ZZ,MaxPower,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	G :=FF;
	F1:= MonomTotal(G,vars);
	W := [op(V),seq( NormalForm(i,F1,plex(vars[1],vars[2])),i=ZZ)];
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				mahsa:= mahsa,MINIMAL1JA([f], F1, W,vars)[-1];
				A3 := MINIMAL1JA([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A1 := MINIMAL1JA([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A2 := MINIMAL1JA([f], F1, W,vars);
				W := A2[1];
			else
				mahsa := mahsa, MINIMAL1JA([f], F1, W,vars)[-1];
				A := MINIMAL1JA([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
				mahsa := mahsa, MINIMAL2JA([f], F1, W,vars)[-1];
				B := MINIMAL2JA([f], F1, W,vars);
				W := B[1];
		elif f[1]=0 and f[2]<>0 then
				mahsa := mahsa, MINIMAL3JA([f], F1, W,vars)[-1];
				C := MINIMAL3JA([f], F1, W,vars);
				W := C[1];
		fi;
	od;
        return(mahsa);
        end:

###########################computations in ring of fractional with truncation####
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Itr1FractionalRing:=proc(Ideal,k,vars)
#option trace;
local LMS,NN,L,Y,F,S,MaxPower,u,M,p,flag,Monoms,m,OUT,SelFun,j,ind,MM,MMM,B,i,MX,NEWPOINT,esfahan;
	F:=[seq(mtaylor(i,vars,k+1),i=Ideal)];
	S:=STD(F,[vars[2],vars[1]],Ds);
	LMS:=LM(S); 
	#flag:=false;
	#for i from 1 to nops(S) while not flag do
	# if indets(LMS[i])={x} then
	# flag:=true;
	#fi;
	#od;
	#if flag then
	# for i from 1 to nops(S) while flag do
	# if indets(LMS[i])={lambda} then
        # flag:=false;
	# fi;
	# od;
	#if flag then
	#  RETURN("The ideal is of infinite codimension.");
	# fi;
	#else
	# RETURN("The ideal is of infinite codimension.");
	#fi;
	MaxPower:=0; 
	NEWPOINT:=NULL; 
	for u in {vars[1],vars[2]} do         
		M:=MultMatrixFractional(S,u):         
		p:=LinearAlgebra:-MinimalPolynomial(M,u):
		NEWPOINT:=NEWPOINT,p;
		MaxPower:=max(MaxPower,degree(p)):  
	od:  
	if nops([op({NEWPOINT} minus {0})])=2 and whattype([NEWPOINT][1])<>`+` and whattype([NEWPOINT][2])<>`+` then
		esfahan:=shiraz;
	else
		RETURN("The ideal is of infinite codimension.");
	fi;
	#RefineTool:=RefineTool union {x^( MaxPower),lambda^( MaxPower)}; 
	flag:=false;  
	while not flag do        
		flag:=true;
		Monoms:= {MonomialMaker( MaxPower,vars)}:
		#Monoms:=Refine(Monoms,RefineTool);        
		for m in Monoms while flag do 
			if MoraNF(m,S)<>0 then                    
				flag:=false;
			else         
				#           RefineTool:=RefineTool union {m};             
			fi;        
		od:        
		if not flag then              
			MaxPower:=MaxPower+1:       
		fi;  
	od:    
	OUT:=[MaxPower];
	if OUT[1]>k then
		print("The truncation degree is not sufficient and the result might be wrong. Suggestion:
 use command Verify to find the appropriate truncation degree.");
	fi;
	M:={seq(MonomialMaker(i,vars),i=1..MaxPower-1)} minus {1,seq(vars[1]^t,t=1..MaxPower-1)};
	for m in M do
		if MoraNF(m,S)<>0 then
			M:=M minus {m};
		fi;
	od;
	SelFun:=proc(k,j,vars)
	if degree(k,vars[2]) >= j then
		RETURN(true);
	fi;
		RETURN(false);
	end:
	j:=1;
	ind:=MaxPower;
	while MM<>{} do
		MM:=select(SelFun,M,j,vars);
		MMM:={seq(expand(m/vars[2]^j),m=MM)};
		if indets(MMM)={vars[2]} and degree(MMM[1])<ind then 
			OUT:=OUT,[0,degree(MM[1])]; 
			M:=M minus {MM[1]}; 
		else
			B:=MaxPower;
			for i from 0 to MaxPower-2 do#by -1 to 1 do# while not flag do
				MX:={MonomialMaker(i,vars)};
				if MX subset MMM then
					flag:=true;
					#OUT:=OUT,[i,j];
					B:=min(B,i);
					#M:=M minus {seq(lambda*mx,mx=MX)};
				fi;
			od;
			if flag and B+j < ind then
				OUT:=OUT,[B,j];
				ind:=B+j;
			fi;
			j:=j+1;
		fi;
	od;
	L:=[MonomialMaker([OUT][1][1],vars),seq(op(expand([MonomialMaker([OUT][i][1],vars)]*vars[2]^[OUT][i][2])),i=2..nops([OUT]))];
	Y:=seq(MoraNF(F[i],L),i=1..nops(F));
	M:='M';
	#L:=subs(y=lambda,L);
	#FF:=subs(y=lambda,F);
	NN:=expand(subs(y=vars[2],{seq(MoraNF(F[i],L),i=1..nops(F))})) minus {0};
	L:=subs(y=vars[2],L);
	NN:={seq(NormalForm(g,L,plex(vars[1],vars[2])),g=NN)};
	if NN={} then
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
	else
		RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<vars[2]^[OUT][i][2]>),i=2..nops([OUT])),NN,vars[1]^[OUT][1][1]+add(vars[1]^[OUT][i][1]*(vars[2]^[OUT][i][2]),i=2..nops([OUT])));
		#    RETURN(L,[Y],M^[OUT][1][1] , add(M^[OUT][i][1]*(<lambda^[OUT][i][2]>),i=2..nops([OUT])),NN);
	fi;
	#RETURN(OUT);  
end:  
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
AlgObjectsFractionalRing:=proc(ggg,k,vars)
#option trace;
local gg, g, S, IT, P0, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, r, R, RNF, N, H, h, ABS;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1FractionalRing(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print("P=",P0);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]+<op(II[5])>);
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
			Temp:=II[3]+II[4];
		else
			print("RT=",II[3]);
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("E/T=",ABS);
	return(GermRecognition(g,vars));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic1FractionalRing:=proc(L,k,vars)
#option trace;
local firsttime, firstbytes, II;
firsttime, firstbytes := kernelopts(cputime, bytesused);
	II:=Itr1FractionalRing(L,k,vars);
	if II[4]<> 0 then 
		print("Intrinsic part is=",II[3]+II[4]);
	else
		print("Intrinsic part is=",II[3]);
	fi; 
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
Intrinsic2FractionalRing:=proc(F,V,k,vars)
#option trace;
local G, f, A, B, C, W, A1, A2, mahsa, A3, a, t, L, K, Kazemi1,Kazemi2,Kazemi3;
global F1;
	Kazemi1:=Itr1FractionalRing(F,k,vars)[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	G := [Kazemi3];
	W := [op(V),op(Itr1(F,vars)[5])];
	F1:= MonomTotal(G,vars);
	mahsa:= NULL;
	for f  in G do
		if f[1]<>0 and f[2]<>0 then
			if f[1]=1 and f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa:= mahsa,MINIMAL1([f], F1, W,vars);
				else
					mahsa:= mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A3 := MINIMAL1([f], F1, W,vars);
				W := A3[1];
			elif f[2]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A1 := MINIMAL1([f], F1, W,vars);
				W := A1[1];
			elif f[1]=1 then
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
					A2 := MINIMAL1([f], F1, W,vars);
					W := A2[1];
			else
				if nops([MINIMAL1([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL1([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL1([f], F1, W,vars)[2];
				fi;
				A := MINIMAL1([f], F1, W,vars);
				W := A[1];
			fi;
		elif f[1]<>0 and f[2]=0 then
				if nops([MINIMAL2([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL2([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL2([f], F1, W,vars)[2];
				fi;
				B := MINIMAL2([f], F1, W,vars);
				W := B[1];
		elif f[1]=0 and f[2]<>0 then
				if nops([MINIMAL3([f],F1,W,vars)])= 1 then
					mahsa := mahsa, MINIMAL3([f], F1, W,vars);
				else
					mahsa := mahsa, MINIMAL3([f], F1, W,vars)[2];
				fi;
				C := MINIMAL3([f], F1, W,vars);
				W := C[1];
		fi;
	od;
	a := NULL;
	for t in [mahsa] do
		a := a, subs(vars[2]^degree(t, vars[2]) = `<,>`(vars[2]^degree(t, vars[2])), t);
	od;
	L := `minus`({op(W)}, {0});
	K := add(i, i = [a]);
	print("Intrinsic part is=",K);
	end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicFractionalRing:=proc(U,V,W,k)
	if _params['U']<>NULL and _params['V']<>NULL and whattype(V)=list and _params['W']<>NULL and whattype(W)=integer and _params['k']=NULL then
		Intrinsic1FractionalRing(U,W,V)
	elif _params['U']<>NULL and _params['V']<>NULL and _params['W']<>NULL and whattype(W)=list and  _params['k']<>NULL and whattype(k)=integer  then
		Intrinsic2FractionalRing(U,V,k,W)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
with(PolynomialIdeals):
NF1FractionalRing:=proc(ggg,k,vars)
#option trace;
local gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,high;
	g:=mtaylor(ggg,vars,k);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	high:=Itr2(S,vars);
	if k<high then
		print("Degree of high order terms start with=",high);
		print("The truncation degree should be higher than or equal to=",high-1);
	fi;
	IT:=Itr1(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2(g,vars)[-1])}; 
	Pperp:={op(NSet(LM(STD(P0,vars,Ds))))};
	A:=Pperp minus Sperp;
	C:={op(IG2(g,vars)[2])}; 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	SS:=NULL;
	d:=nops(Eqs);
	while d>0 do
		C:=choose(nops(Eqs),d);
		for c in C do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					SS:=SS,s;
				fi;
			od;
		od;
		d:=d-1;
	od;
	H:=seq(expand(subs(op(s),g)),s=[SS]);
	RETURN("The set of all possible normal forms is",subs(y=vars[2],{H})); 
    end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
NF_at_non_zero_point := proc(ggg_in,k,vars, point_in)
local ggg, out_nf:
     
      ggg := subs([vars[1]=X+point_in[1], vars[2]=Y+point_in[2]],ggg_in);
      out_nf := NF2FractionalRing(ggg, k, [X,Y]);
      return(subs([X=vars[1],Y=vars[2]],out_nf));
end proc:
###################################second one#
with(PolynomialIdeals):
NF2FractionalRing:=proc(ggg,k,vars)
#option trace;
local t1,gg,g,S,IT,P0,fterms,u,flag,v,Sperp,Pperp,A,C,B,g0,Modifiedg,gterms,Eqs,d,c,E,S2,s,ss,SS,H,high;
	g:=mtaylor(ggg,vars,k);
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	high:=Itr2(S,vars);
	if k<high then
		print("Degree of high order terms starts with=",high);
		print("The truncation degree must be higher than or equal to=",high-1);
	fi;
	IT:=Itr1(S,vars);
	P0:={op(IT[1])};
	g:=NormalForm(g,P0,plex(vars[1],vars[2]));
	Sperp:={op(IG2(g,vars)[-1])}; 
	Pperp:={op(NSet(LM(STD(P0,vars,Ds))))};
	A:=Pperp minus Sperp;
	C:={op(IG2(g,vars)[2])};#subs(lambda=y,{op(IG2(g,[x,lambda])[2])}); 
	B :=A minus C;
	if B={} then
		RETURN(g);
	fi;
	g0:=g;
	g:=subs(vars[1]=a*vars[1]+b*vars[2],g);
	Modifiedg:=g;
	gterms:=NULL;
	Eqs:=NULL;
	while g<>0 do
		gterms:=gterms,LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2]));
		g:=simplify(g-LeadingCoefficient(g,plex(vars[1],vars[2]))*LeadingMonomial(g,plex(vars[1],vars[2])));
		if LeadingMonomial(g,plex(vars[1],vars[2]))in B then
			Eqs:=Eqs,LeadingCoefficient(g,plex(vars[1],vars[2]));
		fi;
	od;
	g:=Modifiedg;
	Eqs:=[Eqs];
	flag:=true;
	d:=nops(Eqs);
	while d>0 and flag do
		C:=choose(nops(Eqs),d);
		for c in C while flag do 
			E:=[seq(Eqs[i] , i=c)];
			S2:=[solve(E)];
			for s in S2 while flag do
				if (Im(eval(a,s))=0 or type(eval(a,s),symbol)) and (Im(eval(b,s))=0 or type(eval(b,s),symbol)) and eval(a,s)<>0 then
					ss:=s;
					flag:=false;
				fi;
			od;
		od;
		if flag then
			d:=d-1;
		fi;
    od;
    g:=expand(subs(ss,g));
    RETURN(subs(a=1,g));
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
##################################option
NormalformFractionalRing:=proc(ggg,vars,z,c)
	if  _params['ggg']<>NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z'] <> NULL and whattype(z)=integer and  _params['c']=NULL  then
		NF2FractionalRing(ggg,z,vars)
	elif  _params['ggg']<>NULL and _params['vars'] <> NULL and whattype(vars)=list and _params['z']<>NULL and whattype(z)=integer  and _params['c'] = list  then
		NF1FractionalRing(ggg,z,vars)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding1FractionalRing:=proc(g_in,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes,g;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	g:=mtaylor(g_in,vars,k+1);
	ET:=PRTT2(g,vars);
	G:=g+add(alpha[i]*ET[i],i=1..nops(ET));
	H:=NormalformFractionalRing(g,vars,k)+add(alpha[i]*ET[i],i=1..nops(ET));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([G,H]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfolding2FractionalRing:=proc(gg,vars,k)
local firsttime, firstbytes, ET, G, H, secondtime, secondbytes, ET1, ET2, G1, G2, G3, G4,g;
#firsttime, firstbytes := kernelopts(cputime, bytesused);
	g:=mtaylor(gg,vars,k+1);
	ET1:=PRTT2(g,vars);
	ET2:=PRTT2new(g,vars);
	G1:=g+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G2:=g+add(alpha[i]*ET2[i],i=1..nops(ET2));
	G3:=NormalformFractionalRing(g,vars,k)+add(alpha[i]*ET1[i],i=1..nops(ET1));
	G4:=NormalformFractional(g,vars)+add(alpha[i]*ET2[i],i=1..nops(ET2));
	#secondtime, secondbytes := kernelopts(cputime, bytesused);
	#printf("%-1s %1s %1s %1s:  %3a %3a\n", The, cpu, time, is, secondtime-firsttime, sec):
	#printf("%-1s %1s %1s:  %3a %3a\n", The, used, memory, secondbytes-firstbytes, bytes):
	#print("universalunfolding germ=",G);
	#print("universalunfolding normalform=",H);
	return([[G1,G2],[G3,G4]]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
UniversalUnfoldingFractionalRing:=proc(a,b,c,d,q)
	if _params['a']<>NULL and _params['b'] <> NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d'] = NULL and _params['q'] = NULL  then
		UniversalUnfolding1FractionalRing(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=integer and _params['d']=list and _params['q'] = NULL then
		UniversalUnfolding2FractionalRing(a,b,c)[1]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c'] <> NULL and whattype(c)=integer and _params['d']=normalform and _params['q'] = NULL then 
		UniversalUnfolding1FractionalRing(a,b,c)[2]
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=normalform and _params['q']=list then  
		UniversalUnfolding2FractionalRing(a,b,c)[2]
	fi;  
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
###########################################that code which combine both recognition
RecognitionProblemFractionalRing:=proc(f,c,v,k)
	if _params['f']<>NULL and _params['c'] <>NULL and whattype(c)=list and _params['v']<>NULL and whattype(v)=integer and _params['k']<>NULL and whattype(k)=NULL then
		germrecognition(NormalformFractionalRing(f,c,v),c)
	elif _params['f']<>NULL and _params['c']<>NULL and whattype(c)=list and _params['v']<>NULL and whattype(v)=integer and _params['k']=universalunfolding then
		RECOGNITION(NormalformFractionalRing(f,c,v),c)
	end if:
 end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
##########################################inja alaki Itr1 ro gozashtam ke laghal payam bede
MultMatrixFractionalRing:=proc(SS,u,k,vars)
global t;
local L,n,M,i,v,j,c,S,high;
#option trace;
	S:=[seq(mtaylor(i,vars,k+1),i=SS)];
	high:=Itr2(S,vars);
	if k<high and evalb({op(S)}={op(SS)})=false then
		print("The truncation degree is not sufficiently high and thus the following results might be wrong.");
		print("The permissible truncation degree starts with degree=",high-1);
	fi;
	L:=NSet(LM(S));
	n:=nops(L);
	M:=Matrix(n);
	for i from 1 to n do
		v:=MoraNF(u*L[i],S);#print(u,uuuu,v,L[i]);
		M[1,i]:=simplify(v,indets(L));
		for j from 2 to n do
			c:=coeff(subs(L[j]=Maple,v),Maple);
			if degree(c)=0 then
				M[j,i]:=c;
			fi;
		od;
	od;
	RETURN(M);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
#########################################################inja ham alaki Itr1 ezafe kardam
MoraNFFractionalRing := proc (f, F,k,vars) 
    local A, ff, L, M, g, SortFun,high; 
    global var, t,h; 
    #option trace; 
	#d:=degree(f);
	h := mtaylor(f,vars,k+1); 
	L := [seq(mtaylor(i,vars,k+1),i=F)]; 
	high:=Itr2(L,vars);
	if k<high and evalb({op(L)}={op(F)})=false then
		print("The truncation degree is not sufficiently high and thus the following results might be wrong.");
		print("The permissible truncation degree starts with degree=",high-1);
	fi;
	M := select(SelFun, L); 
	SortFun := proc (p, q) 
	global t;
	if ecart(p) < ecart(q) or (ecart(p) = ecart(q) and TestOrder(LM(p),LM(q),t)) then 
		RETURN(true): 
	end if; 
	RETURN(false); 
	end proc:
	while nops(M) <> 0 and h <> 0 do
		M := sort(M, SortFun); 
		g := M[1]; 
		if ecart(h) < ecart(g) then 
			L := [h,op(L)]; 
		end if; 
		h := simplify(h-LC(h, T)*LM(h, T)*g/(LC(g, T)*LM(g, T))); 
		h:=Refine(h);
		#if degree(h)> d then print(h); fi;
			if h <> 0 then 
				M := select(SelFun, L); 
			end if; 
	end do; 
	RETURN(h): 
end proc:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
########################################################inja ham alaki gozashtam ke payam bede
STDFractionalRing:=proc(W,V,Tord,k)
 #option trace:
global Moshkel,t,var: 
local A,G,B,f,h,F,p,rds,m,n,i,w,r,H,FF,high:
	FF:=[seq(mtaylor(i,[V[1],V[2]],k+1),i=W)];
	high:=Itr2(FF,V);
	if k<high and evalb({op(W)}={op(FF)})=false then
		print("The truncation degree is not sufficiently high and thus the following results might be wrong.");
		print("The permissible truncation degree starts with degree=",high-1);
	fi;
	#m:=kernelopts(bytesused,cputime):
	var := V; 
	A := poly_algebra(op(var)); 
	t := MonomialOrder(A, ('user')(Tord, var));
	Moshkel:=[seq([f,LT(f,t)],f in FF)]:
	F:=[seq(i,i=1..nops(FF))]:
	G:=[]:B:=[]:
	for i in F do
		F:=[op({op(F)} minus {i})]:
		G,B:=UPDATE(G,B,i):
		#B:=sort(B,f2);
	od:
	rds:=0:
	B:=sort(B,f2);
	while nops(B)<>0 do
		p:=B[1]:
		B:=B[2..-1]:
		#w:=NormalForm(SSPolynomial(Moshkel[p[1]][1],Moshkel[p[2]][1],t),[seq(Moshkel[G[i]][1],i=1..nops(G))],t):
		w:=MoraNF(SPolynomial(Moshkel[p[1]][1],Moshkel[p[2]][1],t),[seq(Moshkel[G[i]][1],i=1..nops(G))]):
		if w=0 then
			rds:=rds+1:
		else
			Moshkel:=[op(Moshkel),[w,LT(w,t)]]:
			G,B:=UPDATE(G,B,nops(Moshkel)):
			#B:=sort(B,f2);
		fi:
	od:
	H:=[seq(Moshkel[G[i]][1],i=1..nops(G))]:
	#n:=kernelopts(bytesused,cputime):
	#print(IsGrobner(FF,H,t));
	# printf("%-1s %1s %1s %1s   : %3a\n",The,Grobner,Basis,is,H):
	# printf("%-1s %1s %1s%1s         : %3a %3a\n",The, cpu, time, is,[n-m][2],(sec)):
	# printf("%-1s %1s %1s        : %5a %3a\n",The,used,memory,[n-m][1],(bytes)):
	# printf("%-1s %1s %1s             : %5g\n",Num,of,Rds,rds):
	#printf("%-1s %1s %1s            : %2a\n",Num,of,poly,nops(G)):
	RETURN(H):
 end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
 ###########################Extra commands related to AlgObjects######################
RT:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		RTFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		RTFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		RTFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		RTFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		RTPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		RTPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		RTFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		RTGerm(a,c,b)
	elif  _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=InfCodim and _params['d']=NULL then
		op(INF1Fractional([a,b[1]*diff(a,b[1]),b[2]*diff(a,b[1])],b))[2]
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
#######RT computations###################################################
RTFractional:=proc(g,vars)
#option trace;
local F,II;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RTFractionalRing:=proc(ggg,k,vars)
local gg, g, F, II;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
RTPolynomial:=proc(ggg,k,vars)
local gg,g,F,II;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
RTPolynomialRing:=proc(ggg,vars)
local g,gg,F,II;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=I",I[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
RTFormal:=proc(ggg,k,vars)
local g,gg,F,II;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
RTGerm:=proc(h,k,vars)
local g,F,II;
	g:=h;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];	
	II:=Itr1Germ(F,vars,k);
	if II[5]<>{} then
		if II[4]<> 0 then 
			print("RT=",II[3]+II[4]+<op(II[5])>);
		else
			print("RT=",II[3]+<op(II[5])>);
		fi;
	else
		if II[4]<>0 then
			print("RT=",II[3]+II[4]);
		else
			print("RT=",II[3]);
		fi;
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
T:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		TFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		TFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		TFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		TFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomia then
		TPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		TPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		TFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		TGerm(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######T computations###################################################
TFractional:=proc(ggg,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
#option trace;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
TFractionalRing:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
TPolynomial:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# { }
# Input:
# {}
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
TPolynomialRing:=proc(ggg,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;	
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
TFormal:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
TGerm:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		 else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';	
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
P:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		PFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		PFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		PFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		PFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		PPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		PPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		PFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		PGerm(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######P computations###################################################
PFractional:=proc(ggg,vars)
local gg, g, S, IT, P0;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PFractionalRing:=proc(ggg,k,vars)
local gg, g, S, IT, P0;
gg:=mtaylor(ggg,vars,k+1);
g:=gg;
S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
IT:=Itr1FractionalRing(S,k,vars);
P0:=IT[3]+IT[4];
g:='g';
print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PPolynomial:=proc(ggg,k,vars)
local gg, g, S, IT, P0;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Polynomial(S,k,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
PPolynomialRing:=proc(ggg,vars)
local gg, g, S, IT, P0;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1PolynomialRing(S,vars);
	P0:=IT[3]+IT[4];
	g:='g';
	print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
PFormal:=proc(ggg,k,vars)
local gg, g, S, IT, P0;
	gg:=ggg;	
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Formal(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: { }
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# {}
#>-----------------------------------------------------------------------------
PGerm:=proc(ggg,k,vars)
local gg, g, S, IT, P0;
	gg:=ggg;
	g:=gg;
	S:=[vars[1]*g,vars[2]*g,vars[1]^2*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	IT:=Itr1Germ(S,vars,k);
	P0:=IT[3]+IT[4];
	g:='g';
	print(P(ggg)=P0);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {}
# Output:
# {}
#>-----------------------------------------------------------------------------
TangentPerp:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		TangentPerpFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL  then
		TangentPerpFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		TangentPerpFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		TangentPerpFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		TangentPerpPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		TangentPerpPolynomialRing(a,b)
	#elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=integer and _params['c']=Formal #then
		# TangetPerpFormal(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerm  then
		TangentPerpGerm(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		 TangentPerpFormal(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######TangentPerp computations###########################################
TangentPerpFractional:=proc(ggg,vars)
#option trace;
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
TangentPerpFractionalRing:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1(F,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=STD({op(ItrPart),op(VecSpace)},vars,Ds);
	gy:=diff(g,vars[2]);
	l:=0;
	while MoraNF(vars[2]^l*gy,SB)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSet([op(LM(SB))]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {}
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
TangentPerpPolynomial:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Polynomial(F,k,vars);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# {}
#>-----------------------------------------------------------------------------
TangentPerpPolynomialRing:=proc(ggg,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1PolynomialRing(F,vars);
	g:='g';	
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=Basis([op(ItrPart),op(VecSpace)],plex(vars[1],vars[2]));
	gy:=diff(g,vars[2]);
	l:=0;
	while NormalForm(vars[2]^l*gy,SB,plex(vars[1],vars[2]))<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LeadingMonomial(f,plex(vars[1],vars[2])),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
TangentPerpFormal:=proc(ggg,k,vars)
#option trace;
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Formal(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisFormal([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgFormal(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LMFormal(f,vars,k),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
TangentPerpGerm:=proc(ggg,k,vars)
local gg, g, F, II, Temp, ItrPart, VecSpace, SB, gy, l, R0, X, Kazemi4, Kazemi1, Kazemi2, Kazemi3, Kazemi, TT, RRefined, S, r, R, RNF, N, H, h, ABS;
	gg:=ggg;
	g:=gg;
	F:=[g,vars[1]*diff(g,vars[1]),vars[2]*diff(g,vars[1])];
	II:=Itr1Germ(F,vars,k);
	g:='g';
	if II[5]<>{} then
		if II[4]<> 0 then 
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	else
		if II[4]<>0 then
			Temp:=II[3]+II[4];
		else
			Temp:=II[3];
		fi;
	fi;
	g:=gg;
	ItrPart,VecSpace:=subs(0=NULL,II[1]),subs(0=NULL,II[2]);
	SB:=StandardBasisGerm([op(ItrPart),op(VecSpace)],vars,k);
	gy:=diff(g,vars[2]);
	l:=0;
	while DivAlgGerm(vars[2]^l*gy,SB,k,vars)<>0 do
		l:=l+1;
	od;
	l:=l-1;
	R0:={diff(g,vars[1]),seq(vars[2]^i*gy,i=0..l)};
	R0:={seq(mtaylor(i,vars,k+1),i=R0)};
	if II[5]<>{} then #print(salaaaam,II[5] union R0 , IntInterReduce(II[5] union R0));
		X:=Temp+R*convert(expand(IntInterReduce(II[5] union R0,vars)),set);
		Kazemi4:=convert(expand(IntInterReduce(II[5] union R0,vars)),list);
	else
		X:=Temp+R*convert(expand(IntInterReduce(R0,vars)),set); #R*expand(subs(y=lambda,R0));
		Kazemi4:=convert(expand(IntInterReduce(R0,vars)),list);
	fi;
	g:='g';
	Kazemi1:=II[-1];
	Kazemi2:=Support(Kazemi1,vars);
	Kazemi3:=seq([degree(s,vars[1]),degree(s,vars[2])],s=Kazemi2);
	Kazemi:=Kazemi3,Kazemi4;
	TT:=modification([Kazemi3],Kazemi4,ggg,vars);
	g:=gg;
	RRefined:=NULL;
	R0:={op(R0)};
	S:=R0;
	for r in R0 do 
		S:=S minus {r};
		RRefined:=RRefined,IntDivAlg(r,{RRefined} union S minus {r},vars);
	od;
	R:={RRefined}union II[5];
	RNF:=[seq(NormalForm(r,II[1],plex(vars[1],vars[2])),r=R)];
	N:=NSett([seq(LMGerm(f,k,vars),f=SB)]);
	RNF:=IntInterReduce(RNF,vars);
	H:=NULL;
	for h in N do 
		H:=H,IntDivAlg(h,{op(RNF),H},vars);
	od;
	ABS:={H}minus{0};
	print("TangentPerp=",ABS);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#################################################required algorithms for the rest#######
GermRecognitionSpecial:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERP(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	return(["S"(h)=mahh,"S^{⊥}"(h)={op(SPERP(add(i,i=[op(P)]),vars))},"intrinsic generators"=P]);
	#print("S=",mahh);#"S"(h)=mahh
	#print("Nonzero condition=",[AB]);
	#print("SPerp=",SPERP(add(i,i=[op(P)]),[x,lambda]));#"S^{⊥}"(h)=SPERP(add(i,i=[op(P)]),[x,lambda])
	#print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionPolynomialSpecial:=proc(h,k,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars)<=degree(g[2],vars) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars)<=degree(g[1],vars) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomial(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	return(["S"(h)=mahh,"S^{⊥}"(h)={op(SPERPPolynomial(add(i,i=[op(P)]),vars,k))},"intrinsic generators=",P]);
	#print("S=",mahh);#"S"(h)=mahh
	#print("Nonzero condition=",[AB]);
	#print("SPerp=",SPERPPolynomial(add(i,i=[op(P)]),[x,lambda],k));#"S^{⊥}"(h)=SPERPPolynomial(add(i,i=[op(P)]),[x,lambda],k)
	#print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionPolynomialRingSpecial:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPPolynomialRing(add(i,i=[op(P)]),vars);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	return(["S"(h)=mahh,"S^{⊥}"(h)={op(SPERPPolynomialRing(add(i,i=[op(P)]),vars))},"intrinsic generators=",P]);
	#print("S=",mahh);#"S"(h)=mahh
	#print("Nonzero condition=",[AB]);
	#print("SPerp=",SPERPPolynomialRing(add(i,i=[op(P)]),[x,lambda]));#"S^{⊥}"(h)=SPERPPolynomialRing(add(i,i=[op(P)]),[x,lambda])
	#print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionFormalSpecial:=proc(h,k,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPFormal(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	return(["S"(h)=mahh,"S^{⊥}"(h)={op(SPERPFormal(add(i,i=[op(P)]),vars,k))},"intrinsic generators=",P]);
	#print("S=",mahh);#"S"(h)=mahh
	#print("Nonzero condition=",[AB]);
	#print("SPerp=",SPERPFormal(add(i,i=[op(P)]),[x,lambda],k));#"S^{⊥}"(h)=SPERPFormal(add(i,i=[op(P)]),[x,lambda],k);
	#print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
GermRecognitionGermSpecial:=proc(h,k,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(vars[1],vars[2]))),i={op(S)})};
	mah:=add(M^degree(j,vars[1])*`<,>`(vars[2]^degree(j,vars[2])),j=P);
	mahh:=subs(`<,>`(1)=1,mah);
	N:=SPERPGerm(add(i,i=[op(P)]),vars,k);
	ll:=1;
	if 1 in N then
		ZC:=f=0;
		ll:=2;
	fi;
	ZC:=[ZC,seq(Diff(f,vars[1]$degree(v,vars[1]),vars[2]$degree(v,vars[2]))=0,v in N[ll..-1])];
	AB:=NULL;
	for q in P do
		AB:=AB,Diff(f,vars[1]$degree(q,vars[1]),vars[2]$degree(q,vars[2]))<>0;
	od;
	return(["S"(h)=mahh,"S^{⊥}"(h)={op(SPERPGerm(add(i,i=[op(P)]),vars,k))},"intrinsic generators"=P]);
	#print("S=",mahh);#"S"(h)=mahh;
	#print("Nonzero condition=",[AB]);
	#print("SPerp=",SPERPGerm(add(i,i=[op(P)]),[x,lambda],k));#"S^{⊥}"(h)=SPERPGerm(add(i,i=[op(P)]),[x,lambda],k)
	#print("intrinsic generators=",P);
	#print("zero condition=",ZC);
  end:
#<-----------------------------------------------------------------------------
# Function: {}
# Description: {}
# Calling sequence:
# { }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
S:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		SFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		SFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		SFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		SFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		SSPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		SPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		SFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		SGerm(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: {}
# Calling sequence:
# { }
# Input:
# {  }
# {}
# Output:
# { }
#>-----------------------------------------------------------------------------
#######S computations###################################################
SFractional:=proc(g,vars)
	return(GermRecognitionSpecial(g,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
SFractionalRing:=proc(ggg,k,vars)
local gg,g;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	return(GermRecognitionSpecial(g,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SSPolynomial:=proc(ggg,k,vars)
local gg,g;
gg:=mtaylor(ggg,vars,k+1);
g:=gg;
return(GermRecognitionPolynomialSpecial(g,k,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: {}
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPolynomialRing:=proc(g,vars)
	return(GermRecognitionPolynomialRingSpecial(g,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------

SFormal:=proc(g,k,vars)
return(GermRecognitionFormalSpecial(g,k,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SGerm:=proc(g,k,vars)
return(GermRecognitionGermSpecial(g,k,vars)[1]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerp:=proc(a,b,c)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		SPerpFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		SPerpFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		SPerpFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		SPerpFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		SPerpPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		SPerpPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		SPerpFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		SPerpGerm(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------

#######SPerp computations###################################################
SPerpFractional:=proc(g,vars)
	return(GermRecognitionSpecial(g,vars)[2]);
end:

#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerpFractionalRing:=proc(ggg,k,vars)
local gg,g;
gg:=mtaylor(ggg,vars,k+1);
g:=gg;
return(GermRecognitionSpecial(g,vars)[2]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerpPolynomial:=proc(ggg,k,vars)
local gg,g;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	return(GermRecognitionPolynomialSpecial(g,k,vars)[2]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerpPolynomialRing:=proc(g,vars)
	return(GermRecognitionPolynomialRingSpecial(g,vars)[2]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# { }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerpFormal:=proc(g,k,vars)
	return(GermRecognitionFormalSpecial(g,k,vars)[2]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# { }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
SPerpGerm:=proc(g,k,vars)
	return(GermRecognitionGermSpecial(g,k,vars)[2]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGen:=proc(a,b,c,d)
	if _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=NULL and _params['d']=NULL then
		IntrinsicGenFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Fractional and _params['d']=NULL then
		IntrinsicGenFractional(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Fractional then  
		IntrinsicGenFractionalRing(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=NULL then  
		IntrinsicGenFractionalRing(a,c,b)   
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Polynomial then
		IntrinsicGenPolynomial(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']=Polynomial and _params['d']=NULL then
		IntrinsicGenPolynomialRing(a,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=Formal then
		IntrinsicGenFormal(a,c,b)
	elif _params['a']<>NULL and _params['b']<>NULL and whattype(b)=list and _params['c']<>NULL and whattype(c)=integer and _params['d']=SmoothGerms then
		IntrinsicGenGerm(a,c,b)
	fi;
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#######IntrinsicGen computations###################################################
IntrinsicGenFractional:=proc(g,vars)
	return(GermRecognitionSpecial(g,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGenFractionalRing:=proc(ggg,k,vars)#k+1
local gg,g;
	gg:=mtaylor(ggg,vars,k);
	g:=gg;
	return(GermRecognitionSpecial(g,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGenPolynomial:=proc(ggg,k,vars)
local gg,g;
	gg:=mtaylor(ggg,vars,k+1);
	g:=gg;
	return(GermRecognitionPolynomialSpecial(g,k,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: { }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGenPolynomialRing:=proc(g,vars)
	return(GermRecognitionPolynomialRingSpecial(g,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGenFormal:=proc(g,k,vars)
	return(GermRecognitionFormalSpecial(g,k,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
IntrinsicGenGerm:=proc(g,k,vars)
	return(GermRecognitionGermSpecial(g,k,vars)[3]);
end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_singular_point_parametric := proc(g_in, params_in, vars_in)
local g_zero_params:
	g_zero_params := subs([seq(i=0,i=params_in)],g_in);
	return(solve({g_zero_params=0, diff(g_zero_params, vars_in[1])=0}, {op(vars_in)}));
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_singular_point := proc(g_in, vars_in)
local g:
	g := g_in;
	return(solve({g=0, diff(g, vars_in[1])=0}, {op(vars_in)}));
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# {Derives the coordinate of a point at which we have a singularity of type_in}
#>-----------------------------------------------------------------------------
detect_special_singularity := proc(g_in, params_in, vars_in, type_in)
local zero_nonzero_monoms, list_of_eq_ineq, solution_out:
	zero_nonzero_monoms := Extract_Derivatives(type_in, vars_in);
	list_of_eq_ineq := {g_in=0,seq(diff(g_in,vars_in[1]$degree(i,vars_in[1]),vars_in[2]$degree(i,vars_in[2]))=0,i in zero_nonzero_monoms[1]),seq(diff(g_in,vars_in[1]$degree(j,vars_in[1]),vars_in[2]$degree(j,vars_in[2]))<>0,j in zero_nonzero_monoms[2])};
	solution_out := solve(list_of_eq_ineq, {op(vars_in)});
	return(solution_out);
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#detect_parametric_variety := proc(g_in, params_in, vars_in, type_in, point_in)
#local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final:
		#vars := vars_in;
		#zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		#list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		#list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                #final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		#subs_out := eval(subs([vars[1]=point_in[1],vars[2]=point_in[1]],{op(list_of_eq),op(final_ineq)}));
		#ideal_final := <op(subs_out)>;
		#return(EliminationIdeal(ideal_final, {op(params_in)}));
#end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_via_elimination := proc(g_in, params_in, vars_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, message_final:
		vars := vars_in;
		zero_nonzero_monoms := Extract_Derivatives(type_in, [x,lambda]);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,x),vars[2]$degree(i,lambda)),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,x),vars[2]$degree(j,lambda)),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := {op(list_of_eq),op(final_ineq)};
		ideal_final := <op(subs_out)>;
		message_final := EliminationIdeal(ideal_final, {op(params_in)});
		if nops(IdealInfo:-Generators(message_final))=0 then 
			print("The bifurcation problem has singularity of",type_in, "for all values of parameters");
		elif evalb(op(IdealInfo:-Generators(message_final))=1) then
			print("There is no singularity of this type in this bifurcation problem.");
		else 
			return(message_final);
		end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_via_elimination_nonzero_option := proc(g_in, params_in, vars_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, message_final, Gb_out, var_required, Empty_Plate, elem, out_plate:
		vars := vars_in;
		zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := [op(list_of_eq),op(final_ineq)];
		var_required := [op(vars_in),seq(eta[i],i=1..nops(list_of_ineq)),op(params_in)];
		Gb_out := Basis(subs_out,plex(op(var_required)));
		Empty_Plate := NULL;
		for elem in Gb_out do
			if evalb(subs([seq(j=0, j=var_required)],elem)<>0) then
				Empty_Plate := 	Empty_Plate, elem;
			end if:
		end do:
		out_plate := [Empty_Plate];
		print("Non-zero conditions are",{seq(k=0,k=out_plate)}, "where the extra parameters are auxiliary");
		
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_subsparams_via_elimination := proc(g, params_in, vars_in,sub_param_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, message_final:
		vars := vars_in;
		g_in := g;
		#g_in := subs(sub_param_in, g);
		zero_nonzero_monoms := Extract_Derivatives(type_in, [x,lambda]);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,x),vars[2]$degree(i,lambda)),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,x),vars[2]$degree(j,lambda)),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := subs(sub_param_in,[op(list_of_eq),op(final_ineq)]);
		ideal_final := <op(subs_out)>;
		message_final := EliminationIdeal(ideal_final, {op(params_in)});
		if nops(IdealInfo:-Generators(message_final))=0 then 
			print("The bifurcation problem has singularity of",type_in, "for all values of parameters");
		elif evalb(op(IdealInfo:-Generators(message_final))=1) then
			print("There is no singularity of this type in this bifurcation problem.");
		else 
			print("yes, when:", {seq(j=0,j=IdealInfo:-Generators(message_final))});
		end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_subsparams_via_elimination_plot := proc(g, params_in, vars_in,sub_param_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, generators_in, P1:
		vars := vars_in;
		g_in := g;
		#g_in := subs(sub_param_in, g);
		zero_nonzero_monoms := Extract_Derivatives(type_in, [x,lambda]);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,x),vars[2]$degree(i,lambda)),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,x),vars[2]$degree(j,lambda)),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := subs(sub_param_in,[op(list_of_eq),op(final_ineq)]);
		ideal_final := <op(subs_out)>;
		generators_in :=IdealInfo:-Generators(EliminationIdeal(ideal_final,{op(params_in)}));
		if nops(generators_in)=0 then
			return("There is no parametric variety to be plotted!");
		end if:
		if nops(params_in)=2 then 
			P1:=implicitplot([op(generators_in )],seq(params_in[i]=-0.5..0.5,i=1..nops(params_in)),color=blue,gridrefine=4);
		elif nops(params_in)=3 then 
			print("underconstruction");
		end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_subsvars_via_elimination := proc(g, params_in, vars_in,sub_vars_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, message_final:
		vars := vars_in;
		g_in := g;
		#g_in := subs(sub_param_in, g);
		zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := subs(sub_vars_in,[op(list_of_eq),op(final_ineq)]);
		ideal_final := <op(subs_out)>;
		message_final := EliminationIdeal(ideal_final, {op(params_in)});
		if nops(IdealInfo:-Generators(message_final))=0 then 
			print("The bifurcation problem has singularity of", type_in, "for all values of parameters");
		elif evalb(op(IdealInfo:-Generators(message_final))=1) then
			print("There is no singularity of this type in this bifurcation problem.");
		else 
			print("The bifurcation problem has singularity of",  type_in, "for all values of parameters when", {seq(j=0,j=IdealInfo:-Generators(message_final))});
		end if:
		#return(EliminationIdeal(ideal_final, {op(params_in)}));
end proc:
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_subsvars_via_elimination_plot := proc(g, params_in, vars_in,sub_vars_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, generators_in, i, P1:
		vars := vars_in;
		g_in := g;
		#g_in := subs(sub_param_in, g);
		zero_nonzero_monoms := Extract_Derivatives(type_in, [x,lambda]);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,x),vars[2]$degree(i,lambda)),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,x),vars[2]$degree(j,lambda)),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := subs(sub_vars_in,[op(list_of_eq),op(final_ineq)]);
		ideal_final := <op(subs_out)>;
		generators_in :=IdealInfo:-Generators(EliminationIdeal(ideal_final,{op(params_in)}));
		if nops(generators_in)=0 then
			return("There is no parametric variety to be plotted!");
		end if:
		if nops(params_in)=2 then 
			P1:=implicitplot([op(generators_in )],seq(params_in[i]=-0.5..0.5,i=1..nops(params_in)),color=blue,gridrefine=4);
		elif nops(params_in)=3 then 
			print("underconstruction");
		end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Verify_Sing_Point:=proc(g,vars)
#option trace;
local i, h, S, P, flag, j, A, B, FLAG, C, DD,Q;
global var, t;
	FLAG:=false;
	for i from 1 to 20 while FLAG=false do
		h:=mtaylor(g,vars,i+1);
		S:=[vars[1]*h,vars[2]*h,vars[1]^2*diff(h,vars[1]),vars[2]*diff(h,vars[1])];
		Q:=Basis(S,plex(op(vars)));
		P:=[Itr1(S,vars)][1];
		flag:=false;
		if P="The ideal is of infinite codimension." then
			flag:=true;
		fi;
		for j from 1 to i+1 while flag=false do 
			A:=[MonomialMaker(j, vars)];
			B:={seq(MoraNF(z,P),z in A)};
			if B={0} then
				flag:=true;
				FLAG:=true;
			fi;
		od;
	od;
	return(j-1);
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_SingPoint_via_elimination := proc(g, params_in, vars_in,sub_SingPoint_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, trunc_in, list_of_ineq_required_befor, list_of_ineq_required_after, message_final:
		vars := vars_in;
		trunc_in := Verify_Sing_Point(type_in,vars);
		g_in := mtaylor(g,vars,trunc_in);
		zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
		list_of_ineq_required_befor := {seq((k/LeadingCoefficient(k,plex(op(params_in)))),k=list_of_ineq)} minus {1};
		list_of_ineq_required_after := {seq(l<>0,l in list_of_ineq_required_befor)};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := subs([vars[1]=sub_SingPoint_in[1],vars[2]=sub_SingPoint_in[2]],[op(list_of_eq),op(final_ineq)]);
		ideal_final := <op(subs_out)>;
		message_final := EliminationIdeal(ideal_final, {op(params_in)});
		if nops(IdealInfo:-Generators(message_final))=0 then 
			print("The bifurcation problem has singularity of",type_in, "for all values of parameters");
		elif evalb(op(IdealInfo:-Generators(message_final))=1) then
			print("There is no singularity of this type in this bifurcation problem.");
		else 
			print("The bifurcation problem has singularity of",type_in, "when",{seq(j=0,j=IdealInfo:-Generators(message_final)), op(list_of_ineq_required_after)});
		end if:
		#return(EliminationIdeal(ideal_final, {op(params_in)}));
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_interval_via_elimination := proc(g, params_in, vars_in,interval_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, plate_in, k:
		plate_in := NULL;
		for k from 1 to nops(interval_in) do
			plate_in := plate_in, lhs(interval_in[k])+one[k]^2-rhs(interval_in[k])[2], lhs(interval_in[k])-two[k]^2-rhs(interval_in[k])[1]:
		end do:
		vars := vars_in;
		g_in := g;
		zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := {op(list_of_eq),op(final_ineq),plate_in};
		ideal_final := <op(subs_out)>;
		return(EliminationIdeal(ideal_final, {op(params_in)}));
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
detect_parametric_variety_with_interval_via_elimination := proc(g, params_in, vars_in,interval_in, type_in)
local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, plate_in, k, message_final:
		plate_in := NULL;
		for k from 1 to nops(interval_in) do
			plate_in := plate_in, lhs(interval_in[k])+one[k]^2-rhs(interval_in[k])[2], lhs(interval_in[k])-two[k]^2-rhs(interval_in[k])[1]:
		end do:
		vars := vars_in;
		g_in := g;
		zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		subs_out := {op(list_of_eq),op(final_ineq),plate_in};
		ideal_final := <op(subs_out)>;
		#return(EliminationIdeal(ideal_final, {op(params_in)}));
		message_final := EliminationIdeal(ideal_final, {op(params_in)});
		if nops(IdealInfo:-Generators(message_final))=0 then 
			print("The bifurcation problem has singularity of",type_in, "for all values of parameters");
		elif evalb(op(IdealInfo:-Generators(message_final))=1) then
			print("There is no singularity of this type in this bifurcation problem.");
		else 
			print("The bifurcation problem has singularity of",type_in, "when",{seq(j=0,j=IdealInfo:-Generators(message_final))});
		end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
#detect_parametric_variety_with_interval_via_elimination_plot := proc(g, params_in, vars_in,interval_in, type_in)
#local vars, zero_nonzero_monoms, list_of_eq, list_of_ineq, final_ineq, subs_out, ideal_final, g_in, plate_in, k, generators_in, P1:
		#plate_in := NULL;
		#for k from 1 to nops(interval_in) do
			#plate_in := plate_in, lhs(interval_in[k])+one[k]^2-rhs(interval_in[k])[2], lhs(interval_in[k])-two[k]^2-rhs(interval_#in[k])[1]:
		#end do:
		#vars := vars_in;
		#g_in := g;
		#zero_nonzero_monoms := Extract_Derivatives(type_in, vars);
		#list_of_eq := {g_in,seq(diff(g_in,vars[1]$degree(i,vars[1]),vars[2]$degree(i,vars[2])),i in zero_nonzero_monoms[1])};
		#list_of_ineq := {seq(diff(g_in,vars[1]$degree(j,vars[1]),vars[2]$degree(j,vars[2])),j in zero_nonzero_monoms[2])};
                #final_ineq := {seq(1-eta[i]*list_of_ineq[i], i=1..nops(list_of_ineq))};
		#subs_out := {op(list_of_eq),op(final_ineq),plate_in};
		#ideal_final := <op(subs_out)>;
		#generators_in :=IdealInfo:-Generators(EliminationIdeal(ideal_final,{op(params_in)}));
		#if nops(params_in)=2 then 
			#P1:=implicitplot([op(generators_in )],seq(params_in[i]=-0.5..0.5,i=1..nops(params_in)),color=blue,gridrefine=4);
		#elif nops(params_in)=3 then 
			#print("underconstruction");
		#end if:
#end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
Extract_Derivatives:=proc(h,vars)
#option trace;
local A, B, i, j, T, C, g, S, P, mah, mahh, N, ll, ZC, AB, q;
	A:={op(h)};
	B:=NULL;
	for i from 1 to nops(A) do
		for j from 1 to nops(A) do
			B:=B,{A[i],A[j]};
		od;
	od;
	T:={B}minus{seq({A[i]},i=1..nops(A))};
	C:=NULL;
	for g in T do
		if degree(g[1],vars[2])<=degree(g[2],vars[2]) and degree(g[1])<=degree(g[2]) then
			C:=C,g[2];
		elif degree(g[2],vars[2])<=degree(g[1],vars[2]) and degree(g[2])<=degree(g[1]) then
			C:=C,g[1];
		fi;
	od;
	S:=h-add(i,i={C});
	P:={seq(i/(LeadingCoefficient(i,plex(op(vars)))),i={op(S)})};
	N:=SPERP(add(i,i=[op(P)]),vars);
	return([{op(N)}minus {1},P]);
  end:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
CheckSingularity := proc()
	if evalb(nargs=7 and lhs(args[4])='VarsPoint' and lhs(args[5])='type' and args[6]='ParametricVariety'and args[7]='plot' ) then
		return(detect_parametric_variety_with_subsvars_via_elimination_plot(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=7 and lhs(args[4])='ParsPoint' and lhs(args[5])='type' and args[6]='ParametricVariety'and args[7]='plot' ) then
		return(detect_parametric_variety_with_subsparams_via_elimination_plot(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=6 and lhs(args[4])='ParsPoint' and lhs(args[5])='type' and args[6]='ParametricVariety') then
		return(detect_parametric_variety_with_subsparams_via_elimination(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=6 and lhs(args[4])='VarsPoint' and lhs(args[5])='type' and args[6]='ParametricVariety') then
		return(detect_parametric_variety_with_subsvars_via_elimination(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=6 and lhs(args[4])='SingularPoint' and lhs(args[5])='type' and args[6]='ParametricVariety') then
		return(detect_parametric_variety_with_SingPoint_via_elimination(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=6 and lhs(args[4])='interval' and lhs(args[5])='type' and args[6]='ParametricVariety') then
		return(detect_parametric_variety_with_interval_via_elimination(args[1], args[2], args[3], rhs(args[4]), rhs(args[5])));
	elif evalb(nargs=6 and lhs(args[4])='type' and args[5]='ParametricVariety' and args[6]='NonZero') then
		return(detect_parametric_variety_via_elimination_nonzero_option(args[1], args[2], args[3], rhs(args[4])));
	#elif evalb(nargs=5 and lhs(args[4])='type' and type(args[5],'list')) then
		#return(detect_parametric_variety(args[1], args[2], args[3], rhs(args[4]), args[5]));
	elif evalb(nargs=5 and lhs(args[4])='type' and args[5]='ParametricVariety') then
		return(detect_parametric_variety_via_elimination(args[1], args[2], args[3], rhs(args[4])));
	elif evalb(nargs=4 and lhs(args[4])='type') then
		return(detect_special_singularity(args[1], args[2], args[3], rhs(args[4])));
	elif evalb(nargs=3) then
		return(detect_singular_point_parametric(args[1], args[2], args[3]));
	elif evalb(nargs=2) then
		return(detect_singular_point(args[1], args[2]));
	end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfoldingPars_simple := proc(G_input, params_in, vars_in)
local G, G_nf, G_codim, probable_list, required_list, list_in, other_params, G_needed, trunc_in, G_in:
	G := eval(subs([seq(i=0, i=params_in)], G_input));#print("hi",G);
	G_nf := Normalform(G, vars_in);
	trunc_in := Verify_Sing_Point(G,vars_in);
	G_codim := nops(SPERP(G_nf, vars_in))-2;
	G_in := mtaylor(G_input, [op(vars_in), op(params_in)], trunc_in);
	if nops(params_in)<G_codim then
		print("The parameters in the system are not sufficient to constitute a universal unfolding.");
	elif nops(params_in)=G_codim then
		if CheckUniversal_old(G_in, params_in, vars_in)[1]=1 then
			print("yes");
		else
			print("The parameters cannot fully play the role of universal unfolding parameters.");
		end if:
	elif  nops(params_in)>G_codim then
		probable_list := choose(params_in, G_codim);
		required_list := NULL;
		for list_in in probable_list do
			other_params := {op(params_in)} minus {op(list_in)};
			G_needed := subs([seq(i=0, i=other_params)], G_in);
			if  CheckUniversal_old(G_needed, list_in, vars_in)[1]=1 then
				required_list := required_list, list_in;	
			end if:
		end do:
		return(required_list);
	end if:
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
UniversalUnfoldingPars := proc()
local a_in, b_in:

	if evalb(nargs=4 and lhs(args[4])='SingularPoint') then 
		a_in := subs([args[3][1]=X+rhs(args[4])[1], args[3][2]=Y+rhs(args[4])[2]], args[1]);
		b_in := UniversalUnfoldingPars_simple(a_in, args[2], [X,Y]);
		return(b_in);
	elif evalb(nargs=3) then
		UniversalUnfoldingPars_simple(args[1], args[2], args[3]);
	end if:	
end proc:
#<-----------------------------------------------------------------------------
# Function: {  }
# Description: { }
# Calling sequence:
# {  }
# Input:
# {  }
# {  }
# Output:
# { }
#>-----------------------------------------------------------------------------
