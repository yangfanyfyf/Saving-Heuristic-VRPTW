
[cap,xyPos,dmdQty]=initDataE22_K4();   
dists=createDist(xyPos);   
savings=SavingDist(dists);
[route1,singleWeight]=CWPSaving(savings,cap,dmdQty(:,2))