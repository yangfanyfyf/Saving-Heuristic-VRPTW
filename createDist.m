function nowDist=createDist(xyPos)   
newXY=xyPos(:,2:3)';   
nowDist=dist(newXY); 
end 