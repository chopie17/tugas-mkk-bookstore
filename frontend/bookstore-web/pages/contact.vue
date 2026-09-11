<template>
  <div class="max-w-4xl mx-auto px-4 py-16">
    <div class="text-center mb-12">
      <span class="px-3.5 py-1.5 rounded-full bg-indigo-50 text-indigo-600 text-xs font-semibold">KONTAK</span>
      <h1 class="text-3xl font-extrabold text-slate-900 mt-4 mb-4">Hubungi Kami</h1>
      <p class="text-slate-600">Ada pertanyaan atau kendala? Kami siap membantu Anda kapan saja.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <div class="bg-white p-8 rounded-3xl border border-slate-200/80 shadow-sm space-y-6">
        <h3 class="font-bold text-lg text-slate-900">Informasi Kontak</h3>

        <div class="flex items-start gap-4">
          <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-xl shrink-0">📍</div>
          <div>
            <h5 class="font-semibold text-slate-800 text-sm">Alamat</h5>
            <p class="text-xs text-slate-500 mt-1">Jl. Pendidikan No. 123, Kota Sekolahan, Indonesia</p>
          </div>
        </div>

        <div class="flex items-start gap-4">
          <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-xl shrink-0">📞</div>
          <div>
            <h5 class="font-semibold text-slate-800 text-sm">Telepon / WhatsApp</h5>
            <p class="text-xs text-slate-500 mt-1">+62 812-3456-7890</p>
          </div>
        </div>

        <div class="flex items-start gap-4">
          <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-xl shrink-0">✉️</div>
          <div>
            <h5 class="font-semibold text-slate-800 text-sm">Email</h5>
            <p class="text-xs text-slate-500 mt-1">support@bookstore.com</p>
          </div>
        </div>

        <div class="pt-4 border-t border-slate-100">
          <NuxtLink to="/user/chat" class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-indigo-600 text-white text-xs font-semibold hover:bg-indigo-700 transition-colors">
            💬 Gunakan Live Chat Langsung
          </NuxtLink>
        </div>
      </div>

      <div class="bg-white p-8 rounded-3xl border border-slate-200/80 shadow-sm">
        <h3 class="font-bold text-lg text-slate-900 mb-4">Kirim Pesan</h3>
        <form @submit.prevent="sendMessage" class="space-y-4">
          <div>
            <label class="block text-xs font-semibold text-slate-700 mb-1">Nama Lengkap</label>
            <input v-model="form.name" type="text" required class="w-full px-3.5 py-2 text-sm rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none" placeholder="Masukkan nama" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-700 mb-1">Email</label>
            <input v-model="form.email" type="email" required class="w-full px-3.5 py-2 text-sm rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none" placeholder="alamat@email.com" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-slate-700 mb-1">Pesan</label>
            <textarea v-model="form.message" rows="4" required class="w-full px-3.5 py-2 text-sm rounded-xl border border-slate-300 focus:ring-2 focus:ring-indigo-500 outline-none" placeholder="Tuliskan pesan Anda..."></textarea>
          </div>
          <button type="submit" class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm transition-colors">
            Kirim Pesan
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const form = reactive({
  name: '',
  email: '',
  message: ''
})

const sendMessage = () => {
  alert('Terima kasih! Pesan Anda telah terkirim.')
  form.name = ''
  form.email = ''
  form.message = ''
}
</script>
