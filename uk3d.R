uk.vgm <- variogram(logt ~ z, spdf,
                    boundaries = c(seq(100,1000,100), seq(2000,45000,5000)))
plot(uk.vgm)

show.vgms()
uk.eye1  <- vgm(psill = 0.155,  model = "Gau",  range=700,  nugget=0.0001)
uk.eye   <- vgm(psill = 0.125,  model = "Sph",  range=35000,  nugget=0,  add.to=uk.eye1)
