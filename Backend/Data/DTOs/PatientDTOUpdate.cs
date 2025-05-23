﻿namespace Hospital.Data.DTOs
{
	public class PatientDTOUpdate
	{
		public string? PatientName { get; set; }
		public string? Email { get; set; }
        public required string Password { get; set; }
        public DateTime DateOfBirth { get; set; }
		public string? ContactInfo { get; set; }
		public string? Address { get; set; }
		public string? InsuranceDetails { get; set; }
		public string? EmergencyContact { get; set; }
	}
}
