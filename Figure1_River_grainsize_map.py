import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# Define the coordinates of the sampling points
points = {
    "Pant": (0.316916, 52.0044, 'Gravel'),
    "Rib": (-0.02936, 51.83917, 'Gravel'),
    "Medway": (0.518439, 51.26798, 'Sandy'),
    "Nadder": (-2.11182, 51.04385, 'Sandy')
}

# Create a Basemap instance for the UK region
m = Basemap(
    projection='merc',
    llcrnrlon=-8.0,
    llcrnrlat=49.5,
    urcrnrlon=2.5,
    urcrnrlat=59.5,
    resolution='i'
)

# Draw coastlines and countries
m.drawcoastlines()
m.drawcountries()

# Draw lat and long lines without overlapping with the map
m.drawparallels(range(50, 60, 1), labels=[1, 0, 0, 0], color='white', linewidth=0.5)
m.drawmeridians(range(-7, 3, 1), labels=[0, 0, 0, 1], color='white', linewidth=0.5)

# Plot the sampling points with river names and dots for each location
for site, (lon, lat, river_type) in points.items():
    x, y = m(lon, lat)
    offset = 1 if site == "Pant" else 0  # Adjust the offset for "Pant" label otherwise is overlaps with the dots
    plt.text(x, y + offset, site, fontsize=10, ha='right', va='bottom' if site == "Pant" else 'top',
             color='black', bbox=dict(facecolor='white', alpha=0.0, edgecolor='none'))  # Set alpha to 0.0 for a transparent box
    legend_color = '#878484' if river_type == 'Gravel' else 'black'  # Brighter grayscale colors for the legend
    m.plot(x, y, 'o', color=legend_color, markersize=8)

# Add a custom legend
legend_labels = {'Gravel': 'Gravel', 'Sandy': 'Sandy'}
handles = [plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='#878484', markersize=8, label=legend_labels['Gravel']),
           plt.Line2D([0], [0], marker='o', color='w', markerfacecolor='black', markersize=8, label=legend_labels['Sandy'])]
plt.legend(handles=handles)

# Show the map where you can adjust the size and save it
plt.show()

