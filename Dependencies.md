# Dependencies

### Libraries Used

We use a number of different libraries besides the typical ones from class (Pandas, Numpy, Sci-kit Learn)

##### In Python:


Flask is used a lightweight host for the public classification webservice. Install with `pip install flask`

##### iPython Notebook Extensions

rpy2 enables R cells in an iPython notebook. Install with `pip install rpy2`

Diagrams are created using tikz/LaTeX inside of iPython. 

```{python}
%install_ext https://raw.githubusercontent.com/mkrphys/ipython-tikzmagic/master/tikzmagic.py
%load_ext tikzmagic
%%tikz --scale 2 --size 300,300 -f jpg
\draw (0,0) rectangle (1,1);
\filldraw (0.5,0.5) circle (.1);
```
This has a further dependency of using ImageMagick, Poppler and pdf2svg. See this [Stackoverflow question](http://stackoverflow.com/questions/32682748/tikz-in-ipython-notebook-no-drawing-created-instead-get-message-no-image-gen)

##### In R:

We use Shiny web framework for the public facing classification user interface

### Other:

SquareSpace hosts the static HTML web site.

ShinyApps.io hosts the public functional user interface.



