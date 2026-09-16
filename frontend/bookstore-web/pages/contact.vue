<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="text-center mb-12">
      <span 
        :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[2px_2px_0px_#1A1A1A]'"
        class="px-3.5 py-1.5 rounded-full text-xs font-black border"
      >KONTAK</span>
      <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-black mt-4 mb-4">Hubungi Kami</h1>
      <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="font-bold text-sm">Ada pertanyaan atau kendala? Kami siap membantu Anda kapan saja.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <div 
        :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100 shadow-xl' : 'bg-[#FFF8EC] border-3 border-black text-slate-900 shadow-[6px_6px_0px_#1A1A1A]'"
        class="p-8 rounded-3xl border space-y-6 transition-colors duration-200"
      >
        <h3 
          :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFE566] text-slate-900 border-2 border-black shadow-[1.5px_1.5px_0px_#1A1A1A]'"
          class="font-black text-lg px-2 py-0.5 rounded-lg border inline-block"
        >Informasi Kontak</h3>

        <div class="flex items-start gap-4">
          <div :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#C8F53F] border-2 border-black text-black shadow-[2px_2px_0px_#1A1A1A]'" class="w-10 h-10 rounded-xl border flex items-center justify-center text-xl shrink-0">📍</div>
          <div>
            <h5 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-sm">Alamat</h5>
            <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="text-xs font-bold mt-1">Jl. Pendidikan No. 123, Kota Sekolahan, Indonesia</p>
          </div>
        </div>

        <div class="flex items-start gap-4">
          <div :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#D4B8FF] border-2 border-black text-black shadow-[2px_2px_0px_#1A1A1A]'" class="w-10 h-10 rounded-xl border flex items-center justify-center text-xl shrink-0">📞</div>
          <div>
            <h5 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-sm">Telepon / WhatsApp</h5>
            <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="text-xs font-bold mt-1">+62 812-3456-7890</p>
          </div>
        </div>

        <div class="flex items-start gap-4">
          <div :class="isDark ? 'bg-indigo-900/60 text-indigo-300 border-indigo-700' : 'bg-[#FFD4A3] border-2 border-black text-black shadow-[2px_2px_0px_#1A1A1A]'" class="w-10 h-10 rounded-xl border flex items-center justify-center text-xl shrink-0">✉️</div>
          <div>
            <h5 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-sm">Email</h5>
            <p :class="isDark ? 'text-slate-400' : 'text-slate-700'" class="text-xs font-bold mt-1">support@bookstore.com</p>
          </div>
        </div>

        <div :class="isDark ? 'border-slate-800' : 'border-t-2 border-black'" class="pt-4 border-t">
          <NuxtLink 
            to="/user/chat" 
            :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white border-indigo-500' : 'bg-[#C8F53F] text-black border-2 border-black shadow-[3px_3px_0px_#1A1A1A] hover:translate-x-[-1px] hover:translate-y-[-1px] active:translate-x-[1px] active:translate-y-[1px]'"
            class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl border text-xs font-black transition-all"
          >
            💬 Gunakan Live Chat Langsung
          </NuxtLink>
        </div>
      </div>

      <div 
        :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100 shadow-xl' : 'bg-[#FFF8EC] border-3 border-black text-slate-900 shadow-[6px_6px_0px_#1A1A1A]'"
        class="p-8 rounded-3xl border transition-colors duration-200"
      >
        <h3 
          :class="isDark ? 'bg-slate-800 text-indigo-400 border-slate-700' : 'bg-[#FFD4A3] text-slate-900 border-2 border-black shadow-[1.5px_1.5px_0px_#1A1A1A]'"
          class="font-black text-lg mb-4 px-2 py-0.5 rounded-lg border inline-block"
        >Kirim Pesan</h3>
        <form @submit.prevent="sendMessage" class="space-y-4">
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-900'" class="block text-xs font-black mb-1">Nama Lengkap</label>
            <input 
              v-model="form.name" 
              type="text" 
              required 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-2 border-black text-slate-900 shadow-[2.5px_2.5px_0px_#1A1A1A]'"
              class="w-full px-3.5 py-2 text-sm rounded-xl border outline-none font-bold transition-all" 
              placeholder="Masukkan nama" 
            />
          </div>
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-900'" class="block text-xs font-black mb-1">Email</label>
            <input 
              v-model="form.email" 
              type="email" 
              required 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-2 border-black text-slate-900 shadow-[2.5px_2.5px_0px_#1A1A1A]'"
              class="w-full px-3.5 py-2 text-sm rounded-xl border outline-none font-bold transition-all" 
              placeholder="alamat@email.com" 
            />
          </div>
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-900'" class="block text-xs font-black mb-1">Pesan</label>
            <textarea 
              v-model="form.message" 
              rows="4" 
              required 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-2 border-black text-slate-900 shadow-[2.5px_2.5px_0px_#1A1A1A]'"
              class="w-full px-3.5 py-2 text-sm rounded-xl border outline-none font-bold transition-all" 
              placeholder="Tuliskan pesan Anda..."
            ></textarea>
          </div>
          <button 
            type="submit" 
            :class="isDark ? 'bg-indigo-600 hover:bg-indigo-700 text-white border-indigo-500 shadow-md shadow-indigo-600/30' : 'bg-[#C8F53F] hover:bg-[#b8e82f] text-black border-2 border-black shadow-[3.5px_3.5px_0px_#1A1A1A] active:translate-x-[1px] active:translate-y-[1px]'"
            class="w-full py-3 rounded-xl border font-black text-sm transition-all"
          >
            Kirim Pesan Sekarang &rarr;
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'landing'
})

const { isDark } = useTheme()

const form = reactive({
  name: '',
  email: '',
  message: ''
})

const sendMessage = () => {
  const toast = useToast()
  toast.success('Terima kasih! Pesan Anda telah terkirim.')
  form.name = ''
  form.email = ''
  form.message = ''
}
</script>

