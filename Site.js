// Smooth scrolling for internal links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Dynamically update the footer with the current year
document.addEventListener("DOMContentLoaded", function() {
    const footerYear = new Date().getFullYear();
    const footerText = document.querySelector('footer p');
    if (footerText) {
        footerText.innerHTML = `&copy; ${footerYear} Blood Gang™️, Inc`;
    }
});

// Example: Adding a simple alert for demo purposes
document.querySelectorAll('.links a').forEach(link => {
    link.addEventListener('click', () => {
        alert('You are about to visit an external site!');
    });
});
