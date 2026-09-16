<template>
  <div 
    class="min-h-screen flex flex-col font-['Space_Grotesk'] antialiased transition-colors duration-300"
    :class="isDark ? 'bg-slate-950 text-slate-100' : 'bg-[#FAF7F0] text-slate-900'"
  >
    <!-- Public Navbar Header -->
    <Navbar />

    <!-- Main Content -->
    <main class="flex-grow max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <slot />
    </main>

    <!-- Public Footer -->
    <Footer />

    <!-- Floating Chat Widget -->
    <FloatingChat />

    <!-- Toast Notifications -->
    <Toast />
  </div>
</template>

<script setup lang="ts">
const { isDark, initTheme } = useTheme()

onMounted(() => {
  initTheme()
})
</script>
