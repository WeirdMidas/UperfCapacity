[Major Changes]
- Changes to the CPUset. Focus on better load balancing between cgroups and saving battery power during idle.
- Removed compatibility with 32-bit SOCs, we will focus only on 64-bit devices, to bring maximum performance and efficiency to modern devices.
- Given Uperf more control over performance demands, with the ability to control frame rate, camera performance, and various other settings that provided Uperf with greater control.
- Integrate the new type of compatible SOC, the "Golden SOCs" to showcase their level of optimization.

[Current Compatibility]

New:    
sdm680/sdm685

All:   
Snapdragon 625/626/660/636/82x/835, 662/665/675/680/685/710/712/730/730g/750g/765/765g/768g/780/778g/778g+, 845/855/855+/860/865/865+/870/888/888+/8gen1/8gen1+

Helio P35/G35/G37/P65/G70/G80/G85/G90T, 700/720/800/810/820/900/920/8000/8100, 1000/1000l/1000+/1100/1200/9000

Exynos 8890/8895/9810/9820/9825/990/1080/2100/2200

Google Tensor gs101

"Gold" SOCs:    
sdm680

[Power Profiles]
- powersave: significant performance constraints, suitable for users with low fluidity requirements.
- balance: moderate performance constraints, suitable for everyday use on mobile devices.
- performance: almost no performance constraints, suitable for everyday use on tablets.
- fast: similar to Performance, with more sustained performance, suitable for mobile gaming.

[Additional Modules]
- sfopt: a surfaceflinger optimization module that provides dynamic refresh rate optimizations and derivatives. Designed to reduce Surfaceflinger power consumption and allow for less jitter.
