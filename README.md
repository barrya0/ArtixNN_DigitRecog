# ArtixNN_DigitRecog
Neural Network Accelerator design on Artix-7 FPGA
(IN-PROGRESS)

Credit to the skeleton and guidance I followed for this design goes to Vipin Kizheppatt. Thank you very much for sharing your knowledge with other engineers to adapt for their own endeavors!

The tutorial I followed can be located here: https://www.youtube.com/watch?v=rw_JITpbh3k

Vipin originally targeted the design on a Zynq board whereas I will be doing it on my Basys3 board with an Artix-7. This project is, on the overall, a bit complicated so I started first by learning about Neural Networks and how they work using Michael Nielsen's book "Neural Networks and Deep Learning". I also followed this awesome youtube series by 3Blue1Brown which can be found here: https://www.youtube.com/watch?v=aircAruvnKk&t=10s. 

Following this, I dove into Vipin's series and began the design. I've so far just uploaded the source files here but will be experimenting further with the design and sharing my findings on considerations I had to make to reduce resource usage, component design effects on maximum frequency, hardware validation, etc.. I'd also like to add separate Readme's describing the top-level design, the sub-modules, simulations for each sub-module, external IP interfacing with custom IP such as the AXI Stream and AXI Lite interfaces, and finally a Readme for all I've learned from tackling this challenge.

Current Progress: 

The design is pretty much done. I've done simulations and am getting good accuracy. I've even run some comparisons comparing accuracy with different data widths, layer designs, ReLU vs Sigmoid, and more. Overall, over 100 test samples, I get 98% accuracy using sigmoid with a data width of 16. This is using nearly all available DSP slices on the board though. And surprisingly 99% accuracy with a data width of 8 and very small DSP usage but of course, more LUTs and FFs. My big obstacle right now is hardware validation. I'm trying my best to really understand how to get everything working.

Then...when all this is done, I've been meaning to use this project as a jumping off point to try a binarized neural network design on my FPGA as well but yeah that may not be for a little while.
