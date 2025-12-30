/**
 * Manager Charts Dashboard
 */

document.addEventListener('DOMContentLoaded', function() {
    // Check if Chart.js is loaded
    if (typeof Chart === 'undefined') {
        console.error('Chart.js failed to load');
        return;
    }

    // Initialize refresh button
    const refreshBtn = document.querySelector('.refresh-button');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', refreshData);
    }

    // Auto-refresh every 5 minutes
    setInterval(refreshData, 300000);
    
    // Chart.js Configuration
    Chart.defaults.font.family = "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";
    Chart.defaults.font.size = 13;
    Chart.defaults.color = '#4a5568';

    // Load data from JSON script tag
    const chartDataEl = document.getElementById('chart-data');
    if (!chartDataEl) {
        console.error('Chart data not found');
        return;
    }
    
    let chartData;
    try {
        chartData = JSON.parse(chartDataEl.textContent);
    } catch (e) {
        console.error('Failed to parse chart data', e);
        return;
    }

    // Initialize Charts
    initStatusChart(chartData.statusChart);
    initTaskTypeChart(chartData.taskTypeChart);
    initPropertyChart(chartData.propertyChart);
    initUserPerformanceChart(chartData.userPerformanceChart);
    initUserActivityChart(chartData.userActivityChart);

    console.log('🚀 Cosmo Manager Dashboard loaded successfully!');
});

function refreshData() {
    const refreshBtn = document.querySelector('.refresh-button');
    if (refreshBtn) {
        refreshBtn.classList.add('loading');
        refreshBtn.textContent = '🔄 Refreshing...';
    }
    
    // Simulate refresh (in real app, this would reload data)
    setTimeout(() => {
        location.reload();
    }, 1000);
}

function initStatusChart(data) {
    const ctx = document.getElementById('statusChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: data.labels,
            datasets: [{
                data: data.data,
                backgroundColor: [
                    'rgba(237, 137, 54, 0.8)',   // Pending - Orange
                    'rgba(66, 153, 225, 0.8)',   // In Progress - Blue  
                    'rgba(72, 187, 120, 0.8)',   // Completed - Green
                    'rgba(245, 101, 101, 0.8)'   // Canceled - Red
                ],
                borderColor: [
                    '#ed8936', '#4299e1', '#48bb78', '#f56565'
                ],
                borderWidth: 3,
                hoverOffset: 15
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 25,
                        font: { size: 14, weight: '600' },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.2)',
                    borderWidth: 1,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = ((value / total) * 100).toFixed(1);
                            return `${label}: ${value} tasks (${percentage}%)`;
                        }
                    }
                }
            },
            cutout: '60%'
        }
    });
}

function initTaskTypeChart(data) {
    const ctx = document.getElementById('taskTypeChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: data.labels,
            datasets: [{
                data: data.data,
                backgroundColor: [
                    'rgba(245, 101, 101, 0.8)',  // Cleaning - Red
                    'rgba(237, 137, 54, 0.8)',   // Maintenance - Orange
                    'rgba(155, 89, 182, 0.8)',   // Inspection - Purple
                    'rgba(52, 73, 94, 0.8)'      // Repair - Dark Blue
                ],
                borderColor: [
                    '#f56565', '#ed8936', '#9b59b6', '#34495e'
                ],
                borderWidth: 3,
                hoverOffset: 15
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 25,
                        font: { size: 14, weight: '600' },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.2)',
                    borderWidth: 1,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = ((value / total) * 100).toFixed(1);
                            return `${label}: ${value} tasks (${percentage}%)`;
                        }
                    }
                }
            },
            cutout: '60%'
        }
    });
}

function initPropertyChart(data) {
    const ctx = document.getElementById('propertyChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'Tasks',
                data: data.data,
                backgroundColor: 'rgba(14, 75, 143, 0.8)',
                borderColor: '#0E4B8F',
                borderWidth: 2,
                borderRadius: 8,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.2)',
                    borderWidth: 1,
                    cornerRadius: 8,
                    callbacks: {
                        title: function(context) {
                            return context[0].label;
                        },
                        label: function(context) {
                            return `${context.parsed.y} tasks`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1, font: { weight: '600' } },
                    title: { display: true, text: 'Number of Tasks', font: { weight: '700', size: 14 } },
                    grid: { color: 'rgba(0, 0, 0, 0.05)' }
                },
                x: {
                    title: { display: true, text: 'Properties', font: { weight: '700', size: 14 } },
                    grid: { display: false }
                }
            }
        }
    });
}

function initUserPerformanceChart(data) {
    const ctx = document.getElementById('userPerformanceChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'bar',
        data: {
            labels: data.labels,
            datasets: [{
                label: 'Completed Tasks',
                data: data.completed,
                backgroundColor: 'rgba(72, 187, 120, 0.8)',
                borderColor: '#48bb78',
                borderWidth: 2,
                borderRadius: 6,
            }, {
                label: 'Total Tasks',
                data: data.total,
                backgroundColor: 'rgba(66, 153, 225, 0.6)',
                borderColor: '#4299e1',
                borderWidth: 2,
                borderRadius: 6,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        padding: 20,
                        font: { size: 14, weight: '600' },
                        usePointStyle: true
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.2)',
                    borderWidth: 1,
                    cornerRadius: 8,
                    callbacks: {
                        afterLabel: function(context) {
                            if (context.datasetIndex === 0) {
                                const total = context.chart.data.datasets[1].data[context.dataIndex];
                                const completed = context.parsed.y;
                                const percentage = total > 0 ? ((completed / total) * 100).toFixed(1) : 0;
                                return `Completion Rate: ${percentage}%`;
                            }
                            return '';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1, font: { weight: '600' } },
                    title: { display: true, text: 'Number of Tasks', font: { weight: '700', size: 14 } },
                    grid: { color: 'rgba(0, 0, 0, 0.05)' }
                },
                x: {
                    title: { display: true, text: 'Team Members', font: { weight: '700', size: 14 } },
                    grid: { display: false }
                }
            }
        }
    });
}

function initUserActivityChart(data) {
    const ctx = document.getElementById('userActivityChart');
    if (!ctx) return;

    new Chart(ctx.getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: data.labels,
            datasets: [{
                data: data.data,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.8)',   // Pink
                    'rgba(54, 162, 235, 0.8)',   // Blue
                    'rgba(255, 206, 86, 0.8)',   // Yellow
                    'rgba(75, 192, 192, 0.8)',   // Teal
                    'rgba(153, 102, 255, 0.8)',  // Purple
                    'rgba(255, 159, 64, 0.8)',   // Orange
                    'rgba(199, 199, 199, 0.8)',  // Grey
                    'rgba(83, 102, 255, 0.8)'    // Indigo
                ],
                borderColor: [
                    '#ff6384', '#36a2eb', '#ffce56', '#4bc0c0',
                    '#9966ff', '#ff9f40', '#c7c7c7', '#5366ff'
                ],
                borderWidth: 3,
                hoverOffset: 12
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        font: { size: 12, weight: '600' },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.2)',
                    borderWidth: 1,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed;
                            return `${label}: ${value} updates`;
                        }
                    }
                }
            },
            cutout: '50%'
        }
    });
}
