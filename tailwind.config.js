/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
      animation: {
        'gradient': 'gradientPulse 25s ease-in-out infinite',
        'float': 'float 4s ease-in-out infinite',
        'bounce-slow': 'bounce 3s ease-in-out infinite',
        'shimmer': 'shimmer 2.5s infinite',
        'rotate': 'rotate 30s linear infinite',
      },
      keyframes: {
        gradientPulse: {
          '0%, 100%': { 
            background: 'linear-gradient(135deg, #1e3c72 0%, #2a5298 25%, #e74c3c 50%, #c0392b 75%, #2c3e50 100%)',
          },
          '25%': { 
            background: 'linear-gradient(135deg, #2a5298 0%, #e74c3c 25%, #c0392b 50%, #2c3e50 75%, #1e3c72 100%)',
          },
          '50%': { 
            background: 'linear-gradient(135deg, #e74c3c 0%, #c0392b 25%, #2c3e50 50%, #1e3c72 75%, #2a5298 100%)',
          },
          '75%': { 
            background: 'linear-gradient(135deg, #c0392b 0%, #2c3e50 25%, #1e3c72 50%, #2a5298 75%, #e74c3c 100%)',
          },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-8px)' },
        },
        bounce: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-6px)' },
        },
        shimmer: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(100%)' },
        },
        rotate: {
          '0%': { transform: 'rotate(0deg)' },
          '100%': { transform: 'rotate(360deg)' },
        },
      },
      backdropBlur: {
        'xs': '2px',
      },
    },
  },
  plugins: [],
}
