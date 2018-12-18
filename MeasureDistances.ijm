// Measure Cumulative Distances
//
// This macro measures�cumulative distances along a 
// segmented line selection or between the points
// of a point selection.

  macro "Measure Cumulative Distances [1]" {
     
     if (!(selectionType==6||selectionType==10))
         exit("Segmented line or point selection required");
     getSelectionCoordinates(x, y);
     
     if (x.length<2)
         exit("At least two points required");
     
     getPixelSize(unit, pw, ph); // img scale
     //n = nResults;
     
     distance = newArray(x.length^2);
     
     for (i = 0; i < x.length ; i++) {
        
        dx = (x[i] - x[i+1])*pw;

        for(j = 0; j < y.length; j++) {
        	
        	dy = (y[j] - y[j+1])*ph;

        	distance[i*j] = sqrt(dx*dx + dy*dy);
        }
        
        
        
        setResult("Distance", i, distance[i]);
     }
     updateResults;
  }
