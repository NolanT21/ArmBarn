//
//  Supabase.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/14/25.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://xdmpkzlexcmdigmxxtvb.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkbXBremxleGNtZGlnbXh4dHZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIyNDY1MzAsImV4cCI6MjA2NzgyMjUzMH0.CMLZtRKCAD0jVmSc1mGti_GXbbHi9AVfNtTLrtFjKlw"
)
